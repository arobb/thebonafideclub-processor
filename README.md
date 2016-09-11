# The Bona Fide Score Processor  
The system that generates the "secret sauce" score for https://thebonafide.club dating app.  


## Sample  
1. Run the sample generator; it creates a sample corpus based on a Watson example  
  `./sample/generate-sample-corpus.sh`

1. Run the corpus processor to run the corpuses through Watson  
  `./process-corpus.sh`

1. Distill down the Watson outputs to the core user score  
  `./extract-profile-values.py`

1. Review the `sample.profile.pretty.json` and `sample.bonafide` files in the `corpus-profiles` directory to see the outputs from Watson (profile) and the distilled score (bonafide)


## Primary execution  
1. Pull down the user-chat histories from The Bona Fide Club
  `./get-corpus.sh`

1. Run the corpus processor to run the corpuses through Watson  
  `for p in ./corpus-profiles/*.corpus; do ./process-corpus.sh "$p"; done`

1. Distill down the Watson outputs to the core user scores  
  `for p in ./corpus-profiles/*.profile; do ./extract-profile-values.py -p "$p"; done`

1. Load the user scores back to The Bona Fide Club
  `./load-profile.sh`
