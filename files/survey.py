#!/usr/bin/python3
#
# $Id: survey.py,v 0.2 2020/09/09 06:20:31 kc4zvw Exp kc4zvw $

""" Simple survey in a Python script """

question_list = [  # tuple of the form (question, answer list, correct answer list)
	('What is the population of New Zealand ?',
	['A:1830', 'B:1543', 'C:1642', 'D:1765'],
	['D', 'd', '4.5', '4']),

	('What year did the first european set foot on New Zealand (Abel Tasman) ?',
	['A:1830', 'B:1543', 'C:1642', 'D:1765'],
	['C', 'c', '1642', '3']),

	('How many Kiwi are there left in New Zealand (Approx) ?',
	['A:2000', 'B:600',  'C:70,000', 'D:100000'],
	['D', 'd', '100000', '4']),

	('How many new babys where born in New Zealand in 2015 ?',
	['A:61,000', 'B:208,000', 'C:98,000', 'D:18,000'],
	['D', 'd', '100000', '4']),
]

def ask_questions():
	right = 0
	wrong = 0

	space = ' '

	for each_question, each_answer, each_correct_answer in question_list:
		print(each_question + '\n' + space.join(each_answer))
		get_answer = input()

		if get_answer in each_correct_answer:
			print('Your answer is correct!\n')
			right += 1
		else:
			print('That is not the answer I had in mind!\n')
			wrong += 1
		print('So far, you answered correctly to {0} questions and incorrectly to {1}. Good luck!'.format(right, wrong))


if __name__ == '__main__':
	ask_questions()


# End of file
