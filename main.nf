params.help = false
params.timestamp = false
params.youtube_url = ''
params.model = 'tiny'

process DOWNLOAD_AUDIO {
  container 'whisper'

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

process WHISPER {
  container 'whisper'

  input:
    path audio_file
    val model

  output:
    path 'transcript.txt'

  script:
    """
    #!/usr/bin/env python3
    import whisper

    model = whisper.load_model("$model")
    result = model.transcribe("$audio_file")
    text_file = open(r'transcript.txt', 'w')
    text_file.write(result['text'])
    """
}

process WHISPER_W_TIMESTAMP {
  container 'whisper'

  input:
    path audio_file
    val model

  output:
    path 'transcript.txt'

  script:
    """
    #!/usr/bin/env python3
    import whisper

    model = whisper.load_model("$model")
    result = model.transcribe("$audio_file")
    with open('transcript.txt', 'a') as f:
      for segment in result['segments']:
        f.write(str(segment['start']) + segment['text'] + '\\n')
    """
}

process PRINT {
  input:
    path transcript
  output:
    stdout
  script:
    """
    cat $transcript
    """
}

workflow {
  if (params.help) {
    print """
      Usage: nextflow run main.nf [options]
      Options:
        --help               Print this help message
        --model       model  Set Whisper model. Options are: tiny, base, small, medium, large
        --timestamp          Print timestamps with each speech segment
        --youtube_url URL    Extract audio from this URL to perform transcription. This option is mandatory
    """
  } else if (params.youtube_url == '') {
    throw new Exception("""
    Mandatory parameter missing!
    You failed to provide a valid YouTube URL with --youtube_url
    For help, run: nextflow run main.nf --help
    """)
  } else {
    DOWNLOAD_AUDIO(params.youtube_url)
    if (params.timestamp) {
      WHISPER_W_TIMESTAMP(DOWNLOAD_AUDIO.out, params.model)
      PRINT(WHISPER_W_TIMESTAMP.out).view()
    } else {
      WHISPER(DOWNLOAD_AUDIO.out, params.model)
      PRINT(WHISPER.out).view()
    }
  }
}