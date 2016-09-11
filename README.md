# The Bona Fide Score Processor  
The system that generates the "secret sauce" score for https://thebonafide.club dating app.  


## Sample  
1. Run the sample generator; it creates a sample corpus based on a Watson example  
  `sample/generate-sample-corpus.sh`

1. Run the corpus processor to run the corpuses through Watson  
  `bin/process-corpus.sh corpus-profiles/sample.corpus`

1. Distill down the Watson outputs to the core user score  
  `bin/extract-profile-values.py -p sample`

1. Review the `sample.profile.pretty.json` and `sample.bonafide` files in the `corpus-profiles` directory to see the outputs from Watson (profile) and the distilled score (bonafide)


## Primary execution  
1. Pull down the user-chat histories from The Bona Fide Club
  `bin/get-corpus.sh`

1. Run the corpus processor to run the corpuses through Watson  
  `for p in ./corpus-profiles/*.corpus; do bin/process-corpus.sh "$p"; done`

1. Distill down the Watson outputs to the core user scores  
  `for p in ./corpus-profiles/*.profile; do bin/extract-profile-values.py -p "${p%.*}"; done`

1. Load the user scores back to The Bona Fide Club
  `bin/load-profile.sh`


## Regular processing  
Move the project to `/opt/thebonafideclub-processor`, and place the provided cron file (`./etc/cron.d/thebonafide-process-score`) in `/etc/cron.d` to trigger the processing pipeline every 5 minutes.
