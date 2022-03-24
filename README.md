# SiriusTask

The goal of this assignment is to evaluate the problem solving skills, UX judgement and code quality of the candidate.

We have a list of cities containing around 200k entries in JSON format. Each entry contains the following information:

  {
    "country":"UA",
    "name":"Hurzuf",
    "_id":707860,
    "coord":{
            "lon":34.283333,
        "lat":44.549999
     }
   }

My Solution 

- First Use VIP-Architecture (Clean Swift Architecture)
- I have preprocessed the list of cities into a dictionary where the key is the city first character in lowercase,
- I've alphabetically sorted all arrays in dictionary values.
- I've written a binary search algorithm to search 
