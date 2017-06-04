# Kaggle_Quora

## Deep NLP - Background

Firstly, let me clarify that DNLP is not to be mistaken for Deep Learning NLP. 

Technique such as topic modeling is generally known as shallow NLP where you try to extract knowledge from text through semantic or syntactic analysis approach i.e., try to form groups by retaining words that are similar, and holds higher weight in a sentence/document. Shallow NLP is less noise than the n-grams; however the key drawback is that it does not specify the role of items in the sentence. 

In contrast DNLP focuses on semantic approach i.e., it detects relationships within the sentences, and further it can be represented or expressed as complex construction of the form such as subject:predicate:object (known as triples or triplets) out of syntactically parsed sentences to retain the context. 

Sentences are made up of any combination of actor, action, object and named entities (person, organizations, locations, dates etc). For example, consider the sentence 'the flat tire was replaced by the driver'. Here driver is the subject (actor), replaced is the predicate (action) and flat tire is the object (action). So the triples for would be driver:replaced:tire, which captures the context of the sentence. Note that triples are one of the forms widely used and you can form similar complex structure based on the domain or problem at hand.

## Disadvantages:

* Sentence level is too structured
* Usage of abbreviations and grammatical errors in sentence will mislead the analysis

In quora's duplicate question identification context, application of triples seems to be sensible, however there is very little work done on this area so no reliable packages are available. I have written my own code and logic which seems to pull the results faily, however there is loads of scope for improvement. I welcome your feedback.


You can learn more about triples from my blog http://www.mswamynathan.com/2017/01/21/triplets-for-concept-extraction-from-english-sentence-deep-nlp/

