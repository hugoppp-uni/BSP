#!/bin/bash
usage(){
  cat <<EOF
  splitfix.sh [OPTIONS] FILE [FILE ...] Split FILE into fixed-size pieces.
  The pieces are 10 lines long, if FILE is a text file.  
  The pieces are 10 kiB long, if FILE is *not* a text file.
  The last piece may be smaller, it contains the rest of the original file.
  The output files bear the name of the input file with a 4-digit numerical suffix.
  The original file can be reconstructed with the command ‘‘cat FILE.*’’

  EXAMPLE:
    splitfix.sh foo.pdf 
    splits foo.pdf into the files 
      foo.pdf.0000 foo.pdf.0001 etc.

    splitfix.sh [-h | --help] This help text
    splitfix.sh --version Print version number

  OPTIONS:
  -h
    --help this help text
  -s  SIZE  size of the pieces
        in lines (for text files)
        or in kiBytes (for other files)
  -v
    --verbose print debugging messages
EOF
}

if [ $# -le 0 ]; then
cat <<EOF
Specify arguments. Use --help for help.
EOF
exit 1
else
  argVerbose=false
  argSize=10
  argFile=""
  while [ $# -gt 0 ]
  do
  key="$1"
  case $key in 
    -h|--help)
        usage
        exit 1 
        ;;
    --version)
cat<<EOF
1.0
EOF
    exit 1
    ;;
    -v|--verbose)
      argVerbose=true
      shift
      ;;
    -s|--size)
      argSize="$2"
      shift
      shift
      ;;
    *)
      argFile="$key"
      shift
      ;;
  esac
  done
fi
if [ "$argSize" -le 0 ]; then
cat <<EOF
size must be larger than 0.
EOF
fi

filetype=`file "$argFile" --mime-type`
if [[ "$filetype" == *:*"text"* ]]; then
  if [[ $argVerbose ]]; then
cat<<EOF
is text
EOF
  fi
  (split "$argFile" -l "$argSize" -a 4)
  #is a textfile
else
  if [ $argVerbose ]; then
cat<<EOF
is text
EOF
  fi
  (split "$argFile" -b "$argSize"K -a 4)
  #is not a textfile
fi
