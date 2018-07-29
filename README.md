# dotfiles

precious dotfiles!

![](screenshots/example.png)

## intro

Loved `KDE Plasma`, loved `i3`.
Used both combined, not completely fallen for `i3`.

I swapped around a lot, but a few [r/unixporn] links motivated me to try out a combination of `KDE` & `i3`, most notable:
* [KDE + i3 - A match made in heaven]
* [KDE + bspwm] (different window manager, but still)

I always loved tilting window managers. `KDE Plasma` and its corresponding window manager `kwin` is not bad, but I wanted to improve my productivity and use my screen estate more efficiently. While I could have done this too with a window tiler like [QuickTile] (see
[ArchWiki - List of applications#Window_tilers] for more), I preferred changing the window manager.
After getting used to the workflow, I felt that I don't really need the KDE environment. So I have thrown it out.

Now I am only using [i3-gaps].
With [polybar] as panel.

## setup

* Window manager: [i3-gaps]
* System panel: [polybar]
* Compositor: `compton`
* Notification daemon: [dunst]
* Font: `Fira Sans/Code`
* Program launcher: `rofi`
* Terminal emulator: `urxvt`
* Shell: `bash`
* Text editor: `neovim`
* Browser: `firefox-nightly`

## special thanks

I would like to thank [mohabaks] for his incredible i3 config, which I modified slightly. Check out his post at reddit: [i3gaps-solarized].

[r/unixporn]: https://www.reddit.com/r/unixporn

[KDE + i3 - A match made in heaven]: https://www.reddit.com/r/unixporn/comments/64mihc/i3_kde_plasma_a_match_made_in_heaven/
[KDE + bspwm]: https://www.reddit.com/r/unixporn/comments/69ei5f/kdebspwm_best_of_both_worlds/

[i3-gaps]: https://github.com/Airblader/i3
[i3-kde]: https://github.com/sLite/i3
[QuickTile]: http://ssokolow.com/quicktile/

[mohabaks]: https://github.com/mohabaks
[i3gaps-solarized]: https://www.reddit.com/r/unixporn/comments/5yhe1h/i3gaps_solarized/

[ArchWiki - List of applications#Window_tilers]: https://wiki.archlinux.org/index.php/list_of_applications#Window_tilers

[polybar]: https://github.com/jaagr/polybar
[dunst]: https://github.com/dunst-project/dunst
