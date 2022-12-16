# nf-whisper <a href="https://gitpod.io/#https://github.com/mribeirodantas/nf-whisper"><img src="https://img.shields.io/badge/Gitpod-ready--to--code-908a85?logo=gitpod" alt="Gitpod ready-to-code" /></a>
`nf-whisper` is a Nextflow pipeline to make use of the OpenAI Whisper pre-trained models and generate transcriptions/translations of audio content. This pipeline does a bit more, such as downloading YouTube videos and extracing the audio part for Whisper.

## Basic instructions
0. If you don't have Nextflow installed in your machine, this is the first step. Get up to date info on installation clicking [here](https://www.nextflow.io). If you already have Whisper and everything required in your machine (unlikely), you can just run the pipeline straight way. This is not recommended though, so we should use something like a container technology, which is what we're going to do next.

1. Start by building the image from the provided Dockerfile (You need Docker installed for that, of course :). From the root directory of this repository, type:
```
docker build . -t whisper
```

2. Then, you can run the pipeline using this Docker container image with the command line below. This YouTube URL contains a short conversation in English, so it shouldn't take more than a couple minutes to run.
```
nextflow run main.nf --youtube_url https://www.youtube.com/watch\?v\=UVzLd304keA --model small.en -with-docker whisper
```

✨ You can also use [Wave](https://seqera.io/wave/) (through the `nf-wave` plugin already bundled with Nextflow) to remotely build on-the-fly the container image for you. For that, you don't need to use `docker build`. Just run with `-with-wave` instead:
```
nextflow run main.nf --youtube_url https://www.youtube.com/watch\?v\=UVzLd304keA --model small.en -resume -with-wave
```

## Let's play!
Now that it's working, you can do something more fancy. Run the command line below to get the transcription with timestamps! You can use either Wave or a docker image if you've built one. The example below uses a docker image built locally named `whisper`:
```
nextflow run main.nf --youtube_url https://www.youtube.com/watch\?v\=UVzLd304keA --model small.en --timestamp -resume -with-docker whisper
```

You can also get the transcriptions from audio files already downloaded with the `--file` parameter:
```
nextflow run main.nf --file audio_sample.wav --model small.en --timestamp -resume -with-docker whisper
```

For more information, check the help page with:
```
nextflow run main.nf --help
```

# Available pre-trained models and languages

There are five model sizes, four with English-only versions, offering speed and accuracy tradeoffs. The table below comprises the available models and their approximate memory requirements and relative speed.


|  Size  | Parameters | English-only model | Multilingual model | Required VRAM | Relative speed |
|:------:|:----------:|:------------------:|:------------------:|:-------------:|:--------------:|
|  tiny  |    39 M    |     `tiny.en`      |       `tiny`       |     ~1 GB     |      ~32x      |
|  base  |    74 M    |     `base.en`      |       `base`       |     ~1 GB     |      ~16x      |
| small  |   244 M    |     `small.en`     |      `small`       |     ~2 GB     |      ~6x       |
| medium |   769 M    |    `medium.en`     |      `medium`      |     ~5 GB     |      ~2x       |
| large  |   1550 M   |        N/A         |      `large`       |    ~10 GB     |       1x       |

For English-only applications, the `.en` models tend to perform better, especially for the `tiny.en` and `base.en` models. It was observed that the difference becomes less significant for the `small.en` and `medium.en` models.

# Acknowledgements

The section above was retrieved from the README of [Matthias Zepper](https://github.com/MatthiasZepper) amazing work on [dockerizing Whisper with support even to GPU](https://github.com/MatthiasZepper/whisper-dockerized)! This Nextflow pipeline was heavily influenced by Matthias' work, the [official OpenAI Whisper GitHub repository](https://github.com/openai/whisper), and some other blog posts I read, mostly [this](https://towardsdatascience.com/whisper-transcribe-translate-audio-files-with-human-level-performance-df044499877) and [this](https://exemplary.ai/blog/openai-whisper).
