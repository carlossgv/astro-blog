POSTS_DIR=~/second-brain/3-resources/blog-posts/
DEST_DIR=./src/content/blog/
FILES=$(ls $POSTS_DIR)

# Determine the appropriate stat command based on the operating system
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  stat_command="stat -c %Y"
elif [[ "$OSTYPE" == "darwin"* ]]; then
  stat_command="stat -f %m"
else
  echo "Unsupported OS type: $OSTYPE"
  exit 1
fi

for FILE in $FILES
do
  echo $FILE
  
  src_file="$POSTS_DIR$FILE"
  dest_file="$DEST_DIR$FILE"
  
  # Get the last modification times
  src_mod_time=$($stat_command "$src_file")
  dest_mod_time=$($stat_command "$dest_file")
  
  if [ ! -f "$dest_file" ] || [ "$src_mod_time" -ne "$dest_mod_time" ]
  then
    # update modDatetime to current
    echo $(date -u +"%Y-%m-%dT%H:%M:%S.000Z")
    sed "s/^modDatetime: .*/modDatetime: $(date -u "+%Y-%m-%dT%H:%M:%S.000Z")/" "$src_file" > tmp
    
    cp tmp "$src_file"
    mv tmp "$dest_file"
  fi
done
