params.file = ''
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
    path 'transcription.txt'

  script:
    """
    #!/usr/bin/env python3
    import whisper

    model = whisper.load_model("$model")
    result = model.transcribe("$audio_file")
    text_file = open(r'transcription.txt', 'w')
    text_file.write(result['text'])
    """
}

process WHISPER_W_TIMESTAMP {
  container 'whisper'

  input:
    path audio_file
    val model

  output:
    path 'transcription.txt'

  script:
    """
    #!/usr/bin/env python3
    import whisper

    model = whisper.load_model("$model")
    result = model.transcribe("$audio_file")
    with open('transcription.txt', 'a') as f:
      for segment in result['segments']:
        f.write(str(segment['start']) + segment['text'] + '\\n')
    """
}

process PRINT {
  input:
    path transcription
  output:
    stdout
  script:
    """
    cat $transcription
    """
}

workflow {
  // Checks for proper parameter handling
  if (params.help) {
    print """
      Usage: nextflow run main.nf [options]
      Options:
        --file        file   Generate transcription from this audio file
        --help               Print this help message
        --model       model  Set Whisper pre-trained model. Options are: tiny, base, small, medium, large. Default: tiny
        --timestamp          Print timestamps with each speech segment
        --youtube_url URL    Extract audio from this YouTube URL to generate transcription
    """
  } else if (params.youtube_url == '' && params.file == '') {
    throw new Exception("""
    Mandatory parameter missing!
    You failed to provide a valid YouTube URL with --youtube_url
    or an audio file with --file
    For help, run: nextflow run main.nf --help
    """)
  } else if (params.youtube_url != '' && params.file != '') {
    throw new Exception("""
    You can not provide --file and --youtube_url at the same time.
    Choose only one of these options each time.
    For help, run: nextflow run main.nf --help
    """)
  // Checking conditions on how to behave
  } else {
    // If it's a YouTube URL, you must download the video and extract audio
    if (params.youtube_url != '') {
    DOWNLOAD_AUDIO(params.youtube_url)
    audio_file = DOWNLOAD_AUDIO.out
    } else {
      audio_file = params.file
    }

    if (params.timestamp) {
      WHISPER_W_TIMESTAMP(audio_file, params.model)
      PRINT(WHISPER_W_TIMESTAMP.out).view()
    } else {
      WHISPER(audio_file, params.model)
      PRINT(WHISPER.out).view()
    }
  }
}