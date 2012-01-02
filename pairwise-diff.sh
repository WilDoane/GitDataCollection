echo "" > ~/diff-final.txt

git log --pretty=format:"%h %p %ai" > ~/diff.temp

while read commit1 commit2 commitdate
do
  echo "\n==================================" >> ~/diff-final.txt
  echo "=   $commit1       $commit2        =" >> ~/diff-final.txt
  echo "=   $commitdate    ="                 >> ~/diff-final.txt
  echo "==================================\n" >> ~/diff-final.txt
  git diff  $commit1 $commit2 >> ~/diff-final.txt
done < ~/diff.temp

rm ~/diff.temp
