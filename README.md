# nf-whisper
Nextflow pipeline to interact with OpenAI Whisper.

1. Start by building the image from the provided Dockerfile. From the root directory of this repository, type:
```
docker build . -t whisper
```

Remember to update `nextflow.config` with the appropriate container image name, in case you chose something other than `whisper`.

2. Then run the command line below to get the transcript with timestamp of a short conversation in English:
```
nextflow run main.nf --youtube_url https://www.youtube.com/watch\?v\=UVzLd304keA --model small.en --timestamp -resume
```

For more information, check the help page with:
```
nextflow run main.nf --help
```
