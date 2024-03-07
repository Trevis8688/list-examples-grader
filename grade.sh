CPATH='.:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar'

rm -rf student-submission
rm -rf grading-area

mkdir grading-area

git clone $1 student-submission
echo 'Finished cloning'


# Draw a picture/take notes on the directory structure that's set up after
# getting to this point

# Then, add here code to compile and run, and do any post-processing of the
# tests

if [ -f "student-submission/ListExamples.java" ]; then
    echo "File found!"
else
    echo "ListExamples.java not found"
    exit 1
fi
#jars
cp -r lib grading-area
#ListExamples
cp student-submission/ListExamples.java grading-area/
# TestListExamples
cp TestListExamples.java grading-area/

cd grading-area
javac -cp $CPATH *.java

if [ $? -ne 0 ]; then
    echo "Compile error!"
    exit 1
else
    echo "Compiled successfully!"
fi 

java -cp $CPATH org.junit.runner.JUnitCore TestListExamples > junit-output.txt

lastLine=$(cat junit-output.txt | tail -n 2 | head -n 1)
if echo "$lastLine" | grep -q "OK"; then
    number=$(echo "$lastLine" | awk '{gsub(/[()]/,"",$2); print $2}')
    echo "Success! You passed all $number tests"
else
    tests=$(echo $lastLine | awk -F'[, ]' '{print $3}')
    failures=$(echo $lastLine | awk -F'[, ]' '{print $6}')
    successes=$((tests - failures))
    echo "last line: $lastLine"
    echo "Your score is $successes / $tests"
fi
