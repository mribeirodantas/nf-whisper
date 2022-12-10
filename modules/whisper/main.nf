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
