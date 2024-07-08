POSTS_DIR=~/second-brain/3-resources/blog-posts/
DEST_DIR=./src/content/blog/
FILES=$(ls $POSTS_DIR)

# for each file, copy it to the blog-posts directory if it doesn't already exist and mofiified date is newer
for FILE in $FILES
do
  if [ ! -f $DEST_DIR$FILE ] || [ $POSTS_DIR$FILE -nt $DEST_DIR$FILE ]
  then
    cp $POSTS_DIR$FILE $DEST_DIR
  fi
done
