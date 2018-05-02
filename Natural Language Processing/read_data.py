import sys
import re
import math
import nltk
from nltk import word_tokenize
from nltk.util import ngrams
from collections import Counter

#brings in the data given the input file
def parse_in(filename):
	inFile = open(filename, "r")

	#will hold all the input data
	data = {}

	#put lines in data as arrays themselves
	for line in inFile:
		#regex objects for matching
		newLine = re.compile("\n")		#catches newline characters
		atText = re.compile("@\S+")		#catches the references to other users
		hashtag = re.compile("#\S+") 	#catches hashtags
		semht = re.compile("#SemST")	#semeval hashtag
		
		#remove specific pieces of line
		line = re.sub(newLine,"",line)	#remove newline character
		line = re.sub(semht,"",line)	#remove semeval hashtag
		
		#split tweet into parts
		tweet = line.split("\t");
	
		#grab user references & hashtags
		atUserList = atText.findall(tweet[2])
		hashtagList = hashtag.findall(tweet[2])

		#remove user refrences & hashtags from tweet text
		tweet[2] = re.sub(atText, "",tweet[2])
		tweet[2] = re.sub(hashtag, "", tweet[2])
	
		#add tweets/hashtags to list as separate element
		tweet.insert(2,atUserList)
		tweet.insert(3,hashtagList)
	
		#add tweet to return value
		data[tweet[0]] = tweet[1:]
	
	#close file
	inFile.close()
	
	del(data["ID"])
	
	return data


#will nake it easier to output the data (does not remove hashtags or @tags)
#can be used to easily re-output data in desired format & quickly change tags based on ID
#this is for test data, so we don't need to train on it anyways
def test_in(filename):
	inFile = open(filename, "r")

	#will hold all the input data
	data = {}

	#put lines in data as arrays themselves
	for line in inFile:
		#remove \n at end of line\
		newLine = re.compile("\n")		#catches newline characters
		
		line = re.sub(newLine,"",line)	#remove newline character
		
		tweet = line.split("\t");

		data[tweet[0]] = tweet[1:]
	
	#close file
	inFile.close()
	
	del(data["ID"])
	
	return data

#test data - putting out into a file format that will be able to be tested against
#note - this should be AFTER stance is labelled
def test_out(data,stances):
	outfile = open("task_A_data_out.txt", "w")
	
	data_out = []
	
	data_out.append("ID\tTarget\tTweet\tStance")
	
	for id in data:
		#change stance
		data[id][2] = stances[id]

		data_out.append(id + "\t" + "\t".join(data[id]))
		
	outfile.write("\n".join(data_out))


#will get a dictionary with:
#all words found (tokenized for a bag of POS-tagged words)
#a collected dictionary to each word key with counts for for/against/none
#return format:
# {pos-tagged word : {target : {against : #, for : #, none: #}}}
def get_word_dict(data):
	
	word_dict = {}
	
	for id in data:
	
		#get values
		target = data[id][0]	#subject of tweet we are evaluating for
		tweet = data[id][3]		#words in actual tweet
		stance = data[id][4]	#labelled stance of tweet

		#get all the words in the tweet
		pos_tagged = nltk.pos_tag(nltk.word_tokenize(tweet))
		
		del_postag  = {'CC', 'DT', 'EX', 'IN', 'IN/that', 'LS', 'POS', 'PP', 'PP$','PRP', 'PRP$', 'SENT', 'SYM', 'TO', 'VB', 'VBD', 'VBG', \
			'VBN', 'VBP', 'VBZ', 'VH', 'VHD', 'VHG', 'VHN', 'VHP', 'VHZ', 'WDT', 'WP', 'WP$', '#', '$', '"', '``', '{', '}', '(', ')', ',', \
			';', '.', ':', '\'\''}
		
		for wrd in pos_tagged:
			postag = wrd[1]
			
			if not postag in del_postag:
				if not wrd in word_dict:
					#add new postagged_word : stance_array entry
					word_dict[wrd] = {}
			
				if not target in word_dict[wrd]:
					word_dict[wrd][target] = {}
			
				if not stance in word_dict[wrd][target]:
					word_dict[wrd][target][stance] = 0
			
				#increment for which favor
				word_dict[wrd][target][stance] += 1
			
	return word_dict		

#will get a dictionary with:
#all hashtags
#a collected dictionary to each hashtag with counts for for/against/none
#return format:
# {hashtag : {target : {against : #, for : #, none: #}
def get_hashtag_dict(data):
	hashtag_dict = {}
	
	for id in data:
	
		#get values
		target = data[id][0]
		hashtags = data[id][2]
		stance = data[id][4]
		
		if len(hashtags) == 0:
			hashtags = {"NONE"}
		
		for ht in hashtags:
			if not ht in hashtag_dict:
				#add new postagged_word : stance_array entry
				hashtag_dict[ht] = {}
				
			if not target in hashtag_dict[ht]:
				hashtag_dict[ht][target] = {}
				
			if not stance in hashtag_dict[ht][target]:
				hashtag_dict[ht][target][stance] = 0
				
			#increment for which favor
			hashtag_dict[ht][target][stance] += 1

	return hashtag_dict

#will get a dictionary with:
#all user references
#a collected dictionary to each user reference with counts for for/against/none
#return format:
# {hashtag : {target : {against : #, for : #, none: #}
def get_user_ref_dict(data):
	user_ref_dict = {}
	
	for id in data:
	
		#get values
		target = data[id][0]
		refs = data[id][1]
		stance = data[id][4]
		
		if len(refs) == 0:
			refs = {"NONE"}
			
		for rf in refs:
			if not rf in user_ref_dict:
				#add new postagged_word : stance_array entry
				user_ref_dict[rf] = {}
				
			if not target in user_ref_dict[rf]:
				user_ref_dict[rf][target] = {}
				
			if not stance in user_ref_dict[rf][target]:
				user_ref_dict[rf][target][stance] = 0
				
			#increment for which favor
			user_ref_dict[rf][target][stance] += 1

	return user_ref_dict
	
#calculates N-grams for 1 line
def calc_n_grams(data_line, n):

	ngrams = []
	
	#create pos-tagged tokens
	wrds = nltk.pos_tag(nltk.word_tokenize(data_line))
	
	#punctuation we want to delete
	del_tk = {'LS', 'SYM', 'SENT', '#', '$', '"', '``', '{', '}', '(', ')', ',', ';', '.', ':', '\'\''}
	
	#go through and remove punctuation in tokens
	pop_ind = []
	
	#collect indexes to delete
	for i in list(range(0,(len(wrds))-1)):
		if wrds[i][1] in del_tk:
			pop_ind.insert(0,i)
			
	#pop the undesired punctuation off the list
	for i in pop_ind:
		del(wrds[i])
	
	if (n <= len(wrds)):
		#add start and end tokens
		wrds.insert(0,("START","SENT_TOKEN"))
		wrds.append(("START","SENT_TOKEN"))

		for i in list(range(0,(len(wrds)-n+1))):
			ng = ()
			for j in list(range(0,n)):
				temp = tuple(wrds[i+j])
				ng = ng + temp
		
			ngrams.append(ng)
			
	return ngrams

#gets a dictionary of n-grams, targets, and stances
#n = the n in n-grams
def get_ngram_dict(data, n):
	ngram_dict = {}
	
	for id in data:
	
		#get values
		target = data[id][0]
		ngrams = calc_n_grams(data[id][3], n)
		stance = data[id][4]
		
		for ng in ngrams:
			if not ng in ngram_dict:
				#add new ngram : stance_array entry
				ngram_dict[ng] = {}
				
			if not target in ngram_dict[ng]:
				#add new ngram : target sub-array
				ngram_dict[ng][target] = {}
				
			if not stance in ngram_dict[ng][target]:
				#if not seen before, initialize ngram : target : stance value
				ngram_dict[ng][target][stance] = 0
				
			#increment for which favor
			ngram_dict[ng][target][stance] += 1
			
	return ngram_dict

#total counts for target & stance
def get_counts(in_data):
	counts = {"all":{"AGAINST":0, "FAVOR":0, "NONE":0}}
	
	for dt in in_data:
		for target in in_data[dt]:
			if not target in counts:
				counts[target] = {"AGAINST":0, "FAVOR":0, "NONE":0}
			for stance in in_data[dt][target]:
					
				#get some values for smoothing
				counts["all"][stance] += in_data[dt][target][stance]
				counts[target][stance] += in_data[dt][target][stance]
				
	return counts
	
def get_top_vals(in_data):
	vals = {}
	
	#go through each value
	for key in in_data:
	
		#go through each target for the value
		for target in in_data[key]:
		
			#add target if not present
			if not target in vals:
				vals[target] = {"number":{"AGAINST": {}, "FAVOR": {}, "NONE": {}}, "polarity":{"AGAINST": {}, "FAVOR": {}, "NONE": {}}}
			
			#check counts for each 
			for stance in in_data[key][target]:
		
				#check counts
				if len(vals[target]["number"][stance]) < 25:
					vals[target]["number"][stance][key] = in_data[key][target][stance]
				else:
					min_id = min(vals[target]["number"][stance].items(), key=lambda x: x[1])[0]
					
					if (in_data[key][target][stance] > vals[target]["number"][stance][min_id]):
						del(vals[target]["number"][stance][min_id])
						vals[target]["number"][stance][key] = in_data[key][target][stance]
				
				#get polarities
				
				pol = get_polarity(in_data[key][target], stance)
				metric = pol*in_data[key][target][stance]
				
				#get polarity metric (involves both polarity and number of times word shows up)
				if len(vals[target]["polarity"][stance]) < 25:
					vals[target]["polarity"][stance][key] = metric
				else:
					min_id = min(vals[target]["polarity"][stance].items(), key=lambda x: x[1])[0]
					
					if (metric > vals[target]["polarity"][stance][min_id]):
						del(vals[target]["polarity"][stance][min_id])
						vals[target]["polarity"][stance][key] = metric
				
	return vals
		
	
def get_stance(test_data, word_data, word_count, word_vals, ht_data, ht_count, ht_vals, usr_data, usr_count, usr_vals, \
	bigram_data, bg_count, bg_vals, trigram_data, tg_count, tg_vals, fourgram_data, fg_count, fg_vals):
	ret = {}
	
	for id in test_data:
		target = test_data[id][0]
		usr_refs = test_data[id][1]
		hashtags = test_data[id][2]
		tweet = test_data[id][3]
		
		ct_list = [word_count, ht_count, usr_count, bg_count, tg_count, fg_count]
		#prob = initialize_probs(ct_list, target)
		prob = {'AGAINST':1, 'FAVOR':1, 'NONE':1}
		
		prob = get_polarity_hmm(word_data, word_count, get_word_dict({id : test_data[id]}), target, prob)
		prob = get_polarity_hmm(bigram_data, bg_count, get_ngram_dict({id : test_data[id]}, 2), target, prob)
		prob = get_polarity_hmm(ht_data, ht_count, get_hashtag_dict({id : test_data[id]}), target, prob)
		prob = get_polarity_hmm(usr_data, usr_count, get_user_ref_dict({id : test_data[id]}), target, prob)
		prob = get_polarity_hmm(trigram_data, tg_count, get_ngram_dict({id : test_data[id]}, 3), target, prob)
		prob = get_polarity_hmm(fourgram_data, fg_count, get_ngram_dict({id : test_data[id]}, 4), target, prob)
		
		prob = get_top_val_prob(word_vals, get_word_dict({id : test_data[id]}), prob)
		prob = get_top_val_prob(bg_vals, get_ngram_dict({id : test_data[id]}, 2), prob)
		prob = get_top_val_prob(ht_vals, get_hashtag_dict({id : test_data[id]}), prob)
		prob = get_top_val_prob(usr_vals, get_user_ref_dict({id : test_data[id]}), prob)
		prob = get_top_val_prob(tg_vals, get_ngram_dict({id : test_data[id]}, 3), prob)
		prob = get_top_val_prob(fg_vals, get_ngram_dict({id : test_data[id]}, 4), prob)
		
		if (prob['AGAINST'] > prob['FAVOR']) and (prob['AGAINST'] > prob['NONE']):
			ret[id] = 'AGAINST'
		elif (prob ['FAVOR'] > prob['AGAINST']) and (prob['FAVOR'] > prob['NONE']):
			ret[id] = 'FAVOR'
		else:
			ret[id] = 'NONE'
		
	return ret

"""
#removed because tweets in a specific subject may be biased
# over-all and maybe initial probabilities should not be 'balanced' to skew
# the results in other possible directions

#initialized probability, adjusting for general bias in data
def initialize_probs(counts_in, target):
	prob = {}
	
	ag_ct = 0
	fv_ct = 0
	nn_ct = 0
	
	for count in counts_in:
		ag_ct = ag_ct + count[target]['AGAINST']
		fv_ct = fv_ct + count[target]['FAVOR']
		nn_ct = nn_ct + count[target]['NONE']
	
	prob['AGAINST'] = 1-(ag_ct/(ag_ct + fv_ct + nn_ct))
	prob['FAVOR'] = 1-(fv_ct/(ag_ct + fv_ct + nn_ct))
	prob['NONE'] = 1-(nn_ct/(ag_ct + fv_ct + nn_ct))
	
	return prob
"""

def get_polarity_hmm(word_data, word_count, tweet, target, prob):
	temp_probs = {'AGAINST':0, 'FAVOR':0, 'NONE':0}

	if len(tweet) == 0:
		tweet = {'NONE'}
	
	#take each word and compute probabilities
	for key in tweet:
		temp_probs = {'AGAINST':0, 'FAVOR':0, 'NONE':0}
		stnc_ct = {'AGAINST':0, 'FAVOR':0, 'NONE':0}
	
		#make sure we've seen the word before (in training data)
		if key in word_data:
		
			#if we have, check if the target appeared in the data for the word
			if target in word_data[key]:
				#if it did, get the stance count
				stnc_ct = word_data[key][target]
				
				temp_probs = stance_target_probs(stnc_ct)
				
				if not (temp_probs['AGAINST'] == 0 or temp_probs['FAVOR'] == 0 or temp_probs['NONE'] == 0):
					#return if conditions are met
					for p_key in prob:
						prob[p_key] = prob[p_key] * temp_probs[p_key]

			else:
				#collect counts of stances for word with ALL targets
				for stnc in stnc_ct:
					for target in word_data[key]:
						if stnc in target:
							stnc_ct[stnc] = stnc_ct[stnc] + word_data[key][target][stnc]
							
				temp_probs = stance_target_probs(stnc_ct)
				
				if not (temp_probs['AGAINST'] == 0 or temp_probs['FAVOR'] == 0 or temp_probs['NONE'] == 0):
					#return if conditions are met
					for p_key in prob:
						prob[p_key] = prob[p_key] * temp_probs[p_key]
					
				stnc_ct = {'AGAINST':0, 'FAVOR':0, 'NONE':0}
		else:
			temp_probs = {'AGAINST':1, 'FAVOR':1, 'NONE':1}
			

	return prob

def stance_target_probs(stnc_ct):
	prob = {"AGAINST":0, "FAVOR":0, "NONE":0}

	#check stance counts - if stances for key/target combo do not exist, they are 0
	if not 'AGAINST' in stnc_ct:
		stnc_ct['AGAINST'] = 0
	if not 'FAVOR' in stnc_ct:
		stnc_ct['FAVOR'] = 0
	if not 'NONE' in stnc_ct:
		stnc_ct['NONE'] = 0
				
	#for each stance, calculate the general probability and the polarity adjustor
	for stance in prob:
		if ((stnc_ct['AGAINST'] + stnc_ct['FAVOR'] + stnc_ct['NONE']) > 0) and \
				(((math.fabs(stnc_ct['AGAINST'] - stnc_ct['FAVOR']) + math.fabs(stnc_ct['AGAINST'] - stnc_ct['NONE']) + math.fabs(stnc_ct['FAVOR'] - stnc_ct['NONE']))) > 0):
			gen_prob = stnc_ct[stance]/(stnc_ct['AGAINST'] + stnc_ct['FAVOR'] + stnc_ct['NONE'])
			pol_prob = get_polarity(stnc_ct, stance)
		
			prob[stance] = gen_prob*pol_prob
		
	return prob
	
def get_polarity(stnc_ct, stance):
	pol_prob = 0

	stnc = {}
	if not 'AGAINST' in stnc_ct:
		stnc['AGAINST'] = 0
	else:
		stnc['AGAINST'] = stnc_ct['AGAINST']
	if not 'FAVOR' in stnc_ct:
		stnc['FAVOR'] = 0
	else:
		stnc['FAVOR'] = stnc_ct['FAVOR']
	if not 'NONE' in stnc_ct:
		stnc['NONE'] = 0
	else:
		stnc['NONE'] = stnc_ct['NONE']

	if ((stnc['AGAINST'] + stnc['FAVOR'] + stnc['NONE']) > 0) and \
		(((math.fabs(stnc['AGAINST'] - stnc['FAVOR']) + math.fabs(stnc['AGAINST'] - stnc['NONE']) + math.fabs(stnc['FAVOR'] - stnc['NONE']))) > 0):
		
		pol_prob = (math.fabs(stnc[stance] - stnc['AGAINST']) + math.fabs(stnc[stance] - stnc['FAVOR']) + math.fabs(stnc[stance] - stnc['NONE']))/ \
		(math.fabs(stnc['AGAINST'] - stnc['FAVOR']) + math.fabs(stnc['AGAINST'] - stnc['NONE']) + math.fabs(stnc['FAVOR'] - stnc['NONE']))
		
	return pol_prob
	
def get_top_val_prob(in_vals, tweet, prob):
	#check all values in tweet
	for val in tweet:
		#check both number and polarity
		for type in in_vals:
			#check all stances
			for stnc in in_vals[type]:
				#if we found the value in the top values
				if val in in_vals[type]:
					#adjust the probability (increase probability for that stance only)
					prob[stnc] = prob[stnc]*(1 + (1/len(in_vals['number'][stnc])))

	return prob
	
	
if (len(sys.argv) < 2):
	print("Could not retrieve file name\nPlease use format:\n  program_name file_name\n")
	quit()

#get filename for tweet data
filename_train = sys.argv[1]
test_file = sys.argv[2]

data_train = parse_in(filename_train)

#retrieve data about tweets
word_data = get_word_dict(data_train)
ht_data = get_hashtag_dict(data_train)
usr_data = get_user_ref_dict(data_train)
bigram_data = get_ngram_dict(data_train,2)
trigram_data = get_ngram_dict(data_train,3)
fourgram_data = get_ngram_dict(data_train,4)

#get total counts
word_count = get_counts(word_data)
ht_count = get_counts(ht_data)
usr_count = get_counts(usr_data)
bg_count = get_counts(bigram_data)
tg_count = get_counts(trigram_data)
fg_count = get_counts(fourgram_data)

#get vals
word_vals = get_top_vals(word_data)
ht_vals = get_top_vals(ht_data)
usr_vals = get_top_vals(usr_data)
bg_vals = get_top_vals(bigram_data)
tg_vals = get_top_vals(trigram_data)
fg_vals = get_top_vals(fourgram_data)

test_data = parse_in(test_file)

test_stances = get_stance(test_data, word_data, word_count, word_vals, ht_data, ht_count, ht_vals, usr_data, usr_count, usr_vals, \
	bigram_data, bg_count, bg_vals, trigram_data, tg_count, tg_vals, fourgram_data, fg_count, fg_vals)

del(word_data)
del(ht_data)
del(usr_data)
del(bigram_data)
del(trigram_data)
del(fourgram_data)
del(word_count)
del(ht_count)
del(usr_count)
del(bg_count)
del(tg_count)
del(fg_count)
del(word_vals)
del(ht_vals)
del(usr_vals)
del(bg_vals)
del(tg_vals)
del(fg_vals)
	
test_data = test_in(test_file)
test_out(test_data,test_stances)