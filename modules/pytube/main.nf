process DOWNLOAD_AUDIO {

  input:
    val youtube_url

  output:
    path "audio.mp4"

  script:
    """
    #!/usr/bin/env python3

    import pytube # download youtube videos

    data = pytube.YouTube("$youtube_url")
    # Convert to audio file
    audio = data.streams.get_audio_only()
    audio.download(filename="audio.mp4")
    """
}