import sys  
import json  
import operator  
# this script accepts a tweeter stream as an input file ( argv[1]) and will output  a list of top-10 hashtags within
# the file supplied
def main():  
      tweet_file = open(sys.argv[1])  
   
      hashtags = {} #dictionary of hashtags occurencies
      for line in tweet_file:  
           tweet = json.loads(line)  
           #search for hashtags, and populate the dictionary  
           if 'entities' in tweet.keys() and tweet["entities"]["hashtags"] != []:  
                for hashtag in tweet["entities"]["hashtags"]:  
                     if hashtag["text"] not in hashtags.keys():  
                          hashtags[hashtag["text"]]=1  
                     else:  
                          hashtags[hashtag["text"]]+=1  
      #sort our dictionary by occurencies  
      sorted_dict = sorted(hashtags.iteritems(), key=operator.itemgetter(1), reverse=True)  
      #print top 10 items in a sorted hashtag dictionary   
      for i in range(10):  
           tag, count = sorted_dict[i]  
           count+=0.0   # to convert to float
           strprint = tag+' '+str(count)  
           encoded_str=strprint.encode('utf-8')  
           print encoded_str  
        
             
   
if __name__ == '__main__':  
      main()  
