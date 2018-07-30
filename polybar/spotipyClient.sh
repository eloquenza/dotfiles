#!/usr/bin/env python

import os
import socket
import sys
import time
import traceback
from concurrent.futures import ThreadPoolExecutor

import click
import dbus
import dbus.mainloop.glib
import spotipy
import spotipy.util as util
from dbus.mainloop.glib import DBusGMainLoop
from gi.repository import GLib
from spotipy import SpotifyException
from spotipy.oauth2 import SpotifyClientCredentials

inactive_color = '%{F#073642}'
active_color = '%{F#268bd2}'
saved_underline = '%{u#cb4b16}'
default_underline = '%{u-}'
default_color = '%{F-}'

server_address = '/tmp/spotifycl-socket'


class Spotify:

    SPOTIFY_BUS = 'org.mpris.MediaPlayer2.spotify'
    SPOTIFY_OBJECT_PATH = '/org/mpris/MediaPlayer2'

    PLAYER_INTERFACE = 'org.mpris.MediaPlayer2.Player'
    PROPERTIES_INTERFACE = 'org.freedesktop.DBus.Properties'

    SAVE_REMOVE = b'save'

    def __init__(self):
        DBusGMainLoop(set_as_default=True)
        self.session_bus = dbus.SessionBus()
        self.last_output = ''
        self.empty_output = True

        # Last shown metadata
        self.last_title = None
        # Whether the current song is added to the library
        self.saved_track = False
        # Whether to ignore the update
        self.ignore = False

        self.setup_spotipy()

    def monitor(self):
        self.setup_properties_changed()
        self.freedesktop = self.session_bus.get_object(
            "org.freedesktop.DBus",
            "/org/freedesktop/DBus"
        )
        self.freedesktop.connect_to_signal(
            "NameOwnerChanged",
            self.on_name_owner_changed,
            arg0="org.mpris.MediaPlayer2.spotify"
        )

        executor = ThreadPoolExecutor(max_workers=2)
        executor.submit(self._start_glib_loop)
        executor.submit(self._start_server)

    def _start_glib_loop(self):
        loop = GLib.MainLoop()
        loop.run()

    def _start_server(self):
        try:
            os.unlink(server_address)
        except OSError:
            if os.path.exists(server_address):
                raise
        sock = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
        sock.bind(server_address)
        sock.listen(5)

        while True:
            connection, client_address = sock.accept()
            try:
                command = connection.recv(16)

                if command == Spotify.SAVE_REMOVE:
                    self.save_remove()
            except Exception as e:
                print(e)
            finally:
                connection.close()

    def stop_server(self):
        self.server_loop.close()

    def send_to_server(self, command: bytes):
        sock = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
        try:
            sock.connect(server_address)
        except socket.error:
            raise

        try:
            sock.sendall(command)
        finally:
            sock.close()

    @property
    def metadata_status(self):
        spotify_properties = dbus.Interface(
            self.spotify,
            dbus_interface=Spotify.PROPERTIES_INTERFACE
        )
        metadata = spotify_properties.Get(
            Spotify.PLAYER_INTERFACE,
            'Metadata'
        )
        playback_status = spotify_properties.Get(
            Spotify.PLAYER_INTERFACE,
            'PlaybackStatus'
        )
        return metadata, playback_status

    def setup_spotipy(self):
        auth = util.prompt_for_user_token(
            username=os.environ.get('SPOTIFY_USERNAME'),
            scope='user-library-read,user-library-modify'
        )
        self.spotipy = spotipy.Spotify(auth=auth)

    def save_remove(self, retry=False):
        try:
            metadata, playback_status = self.metadata_status
            trackid = metadata['mpris:trackid']

            self.ignore = True
            remove = self.saved_track
            self.saved_track = not self.saved_track
            try:
                if remove:
                    self.spotipy.current_user_saved_tracks_delete(tracks=[trackid])
                    self.output(f'{active_color}Removed from library!{default_color}')
                else:
                    self.spotipy.current_user_saved_tracks_add(tracks=[trackid])
                    self.output(f'{active_color}Saved to library!{default_color}')
            except SpotifyException:
                if not retry:
                    # Refresh access token
                    self.setup_spotipy()
                    self.save_remove(retry=True)
                    return
                else:
                    raise
            time.sleep(1)
            self.ignore = False

            metadata, playback_status = self.metadata_status
            self.output_playback_status(
                data={
                    'Metadata': metadata,
                    'PlaybackStatus': playback_status,
                }
            )

        except dbus.DBusException:
            self.output('Could not connect to spotify.')

    def output(self, line):
        if not line:
            self.empty_output = True
        if line != self.last_output:
            print(line, flush=True)
            self.last_output = line

    def setup_spotify(self):
        self.spotify = self.session_bus.get_object(
            Spotify.SPOTIFY_BUS,
            Spotify.SPOTIFY_OBJECT_PATH
        )

    def setup_properties_changed(self):
        try:
            self.setup_spotify()
            self.spotify.connect_to_signal(
                'PropertiesChanged',
                self.on_properties_changed
            )

            if self.empty_output:
                metadata, playback_status = self.metadata_status
                self.output_playback_status(
                    data={
                        'Metadata': metadata,
                        'PlaybackStatus': playback_status,
                    }
                )

        except dbus.DBusException:
            self.output('')

    def output_playback_status(self, data, retry=False):
        if self.ignore:
            return

        metadata = data['Metadata']
        artists = metadata['xesam:artist']
        artist = artists[0] if artists else None

        if not artist:
            self.output('')
            return

        title = metadata['xesam:title']
        playback_status = data['PlaybackStatus']
        same_song = title == self.last_title

        icon = "" if playback_status == 'Playing' else ''
        color = active_color if playback_status == 'Playing' else inactive_color
        saved = saved_underline if same_song and self.saved_track else default_underline
        divider = '-'
        self.output(f'{saved}{color}{icon} {artist} {divider} {title}{default_color}{default_underline}')

        if not same_song:
            self.last_title = title
            trackid = metadata['mpris:trackid']

            try:
                self.update_saved_track(trackid=trackid)
            except SpotifyException:
                # Refresh access token
                self.setup_spotipy()
                self.update_saved_track(trackid=trackid)
            if self.saved_track:
                divider = '-'
                self.output(f'{saved}{color}{icon} {artist} {divider} {title}{default_color}{default_underline}')


    def update_saved_track(self, trackid: str):
        self.saved_track = self.spotipy.current_user_saved_tracks_contains(
            tracks=[trackid]
        )[0]

    def on_properties_changed(self, interface, data, *args, **kwargs):
        self.output_playback_status(data)

    def on_name_owner_changed(self, name, old_owner, new_owner):
        if name == 'org.mpris.MediaPlayer2.spotify':
            if new_owner:
                # Spotify was opened.
                self.setup_properties_changed()
            else:
                # Spotify was closed.
                self.spotify = None
                self.output('')


@click.group()
def cli():
    """Script for listening to Spotify over dbus and adding tracks to your library."""
    pass


@cli.command()
def status():
    """Follow the status of the currently playing song on Spotify."""
    spotify = Spotify()
    spotify.monitor()


@cli.command()
def save_remove():
    """Save/remove the currently playing song to/from your library."""
    spotify = Spotify()
    spotify.send_to_server(Spotify.SAVE_REMOVE)


if __name__ == '__main__':
    cli()
