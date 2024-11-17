/* Write a solution to find the IDs of the invalid tweets. The tweet is invalid if the number of characters used in the content of the tweet is strictly greater than 15.

Return the result table in any order.

The result format is in the following example.
*/


Create table If Not Exists Tweets(tweet_id int, content varchar(50));

insert into Tweets (tweet_id, content) values ('1', 'Let us Code');
insert into Tweets (tweet_id, content) values ('2', 'More than fifteen chars are here!');

select tweet_id
from Tweets
where char_length(content) > 15;

-- OR
select tweet_id
from Tweets
where length(content) > 15;