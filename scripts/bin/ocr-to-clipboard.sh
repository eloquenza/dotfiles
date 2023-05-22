# invokes flameshot to create a screenshot
# which gets piped into tesseract to perform OCR on it to extract the text
# which then gets piped into xclip to make the text available in the clipboard
flameshot gui --raw \
  | tesseract stdin stdout -l eng \
  | xclip -in -selection clipboard
