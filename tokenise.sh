#this turns the non-breakable UTF char into a proper space
#removes the html tags
#separates punctuation
cat $* | sed 's/ / /g;s/\t/ /g' | sed -r 's/<[a-z":;, -]+>//g' | sed -r 's/([,./<>?!"%&^*()])/ \1 /g;s/ +/ /g' | sed "s/'/ ' /g;" 
