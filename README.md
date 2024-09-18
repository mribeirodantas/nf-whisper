<p align="center">
  <a href="https://www.github.com/mribeirodantas/nf-whisper">
    <strong>nf-whisper</strong>
  </a>
  <br />
  <span>Automatic Speech Recognition (ASR) Nextflow pipeline using OpenAI Whisper</span>
</p>
<p align="center">
  <a href="https://gitpod.io/#https://github.com/mribeirodantas/nf-whisper">
    <img src="https://img.shields.io/badge/Gitpod-%20Run%20nf_whisper%20on%20Gitpod-908a85?logo=gitpod" alt="Run nf-whisper on Gitpod!" />
  </a>
  <br />
  <a href="https://github.com/codespaces/new?hide_repo_select=true&ref=main&repo=575876376">
    <img src="https://github.com/codespaces/badge.svg" alt="Open on GitHub Codespaces" />
  </a>
</p>

# Introduction

`nf-whisper` is a simple Nextflow pipeline that leverages OpenAI's Whisper pre-trained models to generate transcriptions and translations from YouTube videos and audio files. Key features include:

- Automatic transcription and translation of audio content
- YouTube video downloading and audio extraction
- Support for various Whisper pre-trained models
- Flexible input options: YouTube URLs or local audio files
- Optional timestamp generation for transcriptions

This pipeline streamlines the process of converting speech to text, making it easier for researchers, content creators, and developers to work with audio data.

## Prerequisites and Setup

1. Install Nextflow:
   If you don't have Nextflow installed, visit [nextflow.io](https://www.nextflow.io) for installation instructions.

2. Install Docker:
   This pipeline uses Docker to manage dependencies. Install Docker from [docker.com](https://www.docker.com/get-started).

3. Build the Docker image (or use Wave)
   From the root directory of this repository, run:
   ```
   docker build . -t whisper
   ```
   Or alternatively, you can use [Wave](https://seqera.io/wave/) to remotely build the container image on-the-fly. Just run the Nextflow commands below using `-with-wave` instead of `-with-docker whisper`.

## Getting Started

1. Install Nextflow and Docker (if not already installed).

2. Run the pipeline by providing a YouTube URL using the `--youtube_url` parameter:
   ```
   nextflow run main.nf --youtube_url https://www.youtube.com/watch\?v\=UVzLd304keA --model small.en -with-docker whisper
   ```

3. For local audio files use the `--file` parameter:
   ```
   nextflow run main.nf --file audio_sample.wav --model small.en -with-docker whisper
   ```


## Let's play!

Now that you have the basic setup working, let's explore more advanced features.

1. Generating transcriptions with timestamps using the `--timestamp` parameter:
```
nextflow run main.nf --youtube_url https://www.youtube.com/watch\?v\=UVzLd304keA --model small.en --timestamp -with-docker whisper
```
2. Use different models using the `--model` parameter:
```
nextflow run main.nf --youtube_url https://www.youtube.com/watch\?v\=UVzLd304keA --model tiny -with-docker whisper

```
3. Provide a local model file using the `--model` parameter:
```
nextflow run main.nf --youtube_url https://www.youtube.com/watch\?v\=UVzLd304keA --model /path/to/model.pt -with-docker whisper
```

4. Check out help with:
```
nextflow run main.nf --help
```

# Available pre-trained models and languages
There are five model sizes, four with English-only versions, offering speed and accuracy tradeoffs. The table below shows the available models and their approximate memory requirements and relative speed.

|  Size  | Parameters | English-only model | Multilingual model | Required VRAM | Relative speed |
|:------:|:----------:|:------------------:|:------------------:|:-------------:|:--------------:|
|  tiny  |    39 M    |     `tiny.en`      |       `tiny`       |     ~1 GB     |      ~32x      |
|  base  |    74 M    |     `base.en`      |       `base`       |     ~1 GB     |      ~16x      |
| small  |   244 M    |     `small.en`     |      `small`       |     ~2 GB     |      ~6x       |
| medium |   769 M    |    `medium.en`     |      `medium`      |     ~5 GB     |      ~2x       |
| large  |   1550 M   |        N/A         |      `large`       |    ~10 GB     |       1x       |

For English-only applications, the `.en` models tend to perform better, especially for the `tiny.en` and `base.en` models. The performance difference becomes less significant for the `small.en` and `medium.en` models.

# Acknowledgements

The section above was retrieved from the README of [Matthias Zepper](https://github.com/MatthiasZepper) amazing work on [dockerizing Whisper with support for GPUs](https://github.com/MatthiasZepper/whisper-dockerized)! This Nextflow pipeline was heavily influenced by Matthias' work, the [official OpenAI Whisper GitHub repository](https://github.com/openai/whisper), and some other blog posts I read, mostly [this](https://towardsdatascience.com/whisper-transcribe-translate-audio-files-with-human-level-performance-df044499877) and [this](https://exemplary.ai/blog/openai-whisper).
