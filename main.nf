// default YouTube URL to test
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
    import sys

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
    import sys

    model = whisper.load_model("$model")
    result = model.transcribe("$audio_file")
    # result = model.transcribe(video_filename, task='translate')

    text_file = open(r'transcript.txt', 'w')
    text_file.write(result['text'])
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
  DOWNLOAD_AUDIO(params.youtube_url)
  WHISPER(DOWNLOAD_AUDIO.out, params.model)
  PRINT(WHISPER.out).view()
}