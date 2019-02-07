# mStream Flutter

Android and iPhone apps for [mStream Server](https://github.com/IrosTheBeggar/mStream)

# This Project Needs Some Help

Currently Flutter does not have a way to handle background audio for iOS.  If you are an iOS developer who wants to help implement this, let me know.

# Features Todo List

### High Priority
* Implement the audio_service library
* Player Error Handling (waiting on: https://github.com/luanpotter/audioplayers/issues/106)

### Low Priority
* Save/delete/update playlists
* Auto DJ
* Search Feature
* Re-arrange queue / Re-arrange servers
* Redo UI to add a new server

## Sync Features
Basic File syncing is implemented.  There's a lot to do to make it a seamless user experience though

* Move downloads to Flutter Downloaded (waiting on: https://github.com/fluttercommunity/flutter_downloader/issues/41)
* Play local files from the local file explorer
* Sync Album
* Sync Playlist
* Sync Artists
* Sync Folder
* Better UI for letting the user know which songs are synced
* Compress files for syncing (low priority)
* Highlight songs in explorer if they are synced (low priority)
* Update duplicate songs on sync (low priority)

### Extra Low Priority
* Clicking on the cloud button before adding a server throws an exception (only happens on emulators)
* Add server with QR code (QR code scanners for flutter need some improvement first)
* Display Album Art for albums (Image resizing for network images currently sucks)
* Update all metadata instances after a star rating
