


def open_file():
    while True:
        file_name = input("Enter a class file to grade (i.e. class1 for class1.txt):")
        file_name_extra =  './Data_Files/' + file_name + ".txt"
        print(file_name_extra)
        try:
            with open(file_name_extra, "r+") as file:
                contents = file.read()
        except FileNotFoundError:
            print(f"Error: File '{file_name_extra}' not found.")
            continue
        else:
            print(f"Successfully opened {file_name_extra}.txt")
            file.close()
            break


def analyze_file():
    opened_files = []
    default = True
    for nums in range(8):
        while default:
            file_name = input("Enter a class file to grade (i.e. class1 for class1.txt):")
            file_name_extra =  './Data_Files/' + file_name + ".txt"
            try:
                if file_name in opened_files:
                    print('This file has already opened')
                    continue
                else:
                    file = open(file_name_extra,'r+')
            except FileNotFoundError:
                print(f"Error: File '{file_name_extra}' not found.")
                continue
            else:
                print(f"Successfully opened {file_name_extra}.txt")
                opened_files.append(file_name)
                break

        count = 0
        error = 0
    
        print("**** ANALYZING ****")
        lst_error = []
        
        for line in file.readlines():
            count += 1
            lst_value = line.rstrip('\n').split(',')
            if len(lst_value) != 26:
                print(f"Invalid line of data: does not contain exactly 26 values:\n{line}")
                lst_error.append(lst_value[0])
                error += 1
            elif not lst_value[0][1:].isnumeric() or lst_value[0] == 'N' or len(lst_value[0]) != 9:
                print(f"Invalid line of data: N# is invalid\n{line}")
                lst_error.append(lst_value[0])
                error += 1
    
    
        if error == 0:
            print("No errors found!")
            print("**** REPORT ****")
            print(f"Total valid lines of data: {count}")
            print(f"Total invalid lines of data: {error}")
        else:
            print("**** REPORT ****")
            print(f"Total valid lines of data: {count - error}")
            print(f"Total invalid lines of data: {error}")

        
    
def scoring():
    opened_files = []
    answer_key = "B,A,D,D,C,B,D,A,C,C,D,B,A,B,A,C,B,D,A,C,A,A,B,D,D"
    while True:
        for _ in range(8):
            while True:
                file_name = input("Enter a class file to grade (i.e. class1 for class1.txt): ")
                file_name_extra = './Data_Files/' + file_name + ".txt"
                try:
                    if file_name in opened_files:
                        print('This file has already been opened')
                        continue
                    else:
                        file = open(file_name_extra, 'r')
                except FileNotFoundError:
                    print(f"Error: File '{file_name_extra}' not found.")
                    continue
                else:
                    print(f"Successfully opened {file_name_extra}.txt")
                    opened_files.append(file_name)
                    break

            count = 0
            error = 0
            grade = []

            print("**** ANALYZING ****")
            lst_valid = []

            for line in file:
                count += 1
                lst_value = line.rstrip('\n').split(',')
                if len(lst_value) != 26:
                    print(f"Invalid line of data: does not contain exactly 26 values:\n{line}")
                    error += 1
                elif not lst_value[0][1:].isnumeric() or lst_value[0] == 'N' or len(lst_value[0]) != 9:
                    print(f"Invalid line of data: N# is invalid\n{line}")
                    error += 1
                else:
                    lst_valid.append(lst_value)

            for line in lst_valid:
                score = 0
                check_value = line[1:]
                for i in range(25):
                    if check_value[i] == '':
                        score += 0
                    elif check_value[i] == answer_key.split(',')[i]:
                        score += 4
                    else:
                        score -= 1
                # Ensure the score doesn't go below 0
                score = max(0, score)
                grade.append(score)

            if error == 0:
                print("No errors found!")
                print("**** REPORT ****")
                print(f"Total valid lines of data: {count}")
                print(f"Total invalid lines of data: {error}")
            else:
                print("**** REPORT ****")
                print(f"Total valid lines of data: {count - error}")
                print(f"Total invalid lines of data: {error}")

            total = sum(score > 80 for score in grade)

            sorted_score = sorted(grade)
            midpoint = len(grade) // 2
            median = sorted_score[midpoint] if len(grade) % 2 != 0 else (sorted_score[midpoint - 1] + sorted_score[midpoint]) / 2

            print(f"Total student of high scores: {total}")
            print(f"Mean (average) score: {round(sum(grade) / len(grade), 3)}")
            print(f"Highest score: {max(grade)}")
            print(f"Lowest score: {min(grade)}")
            print(f"Range of scores: {max(grade) - min(grade)}")
            print(f"Median score: {median}")

            skipped_questions = {}
            wrong_answers = {}
            total_students = len(lst_valid)

            for line in lst_valid:
                answers = line[1:]
                for idx, answer in enumerate(answers, start=1):
                    if answer == '':
                        skipped_questions[idx] = skipped_questions.get(idx, 0) + 1
                    elif answer != answer_key.split(',')[idx - 1]:
                        wrong_answers[idx] = wrong_answers.get(idx, 0) + 1

            sorted_skipped = sorted(skipped_questions.items(), key=lambda x: x[1], reverse=True)
            sorted_wrong = sorted(wrong_answers.items(), key=lambda x: x[1], reverse=True)

            max_skip_count = sorted_skipped[0][1]
            max_wrong_count = sorted_wrong[0][1]

            print("Question that most people skip:", end=" ")
            for idx, (question, count) in enumerate(sorted_skipped):
                if count == max_skip_count:
                    if idx > 0:
                        print(",", end=" ")
                    print(f"{question} - {count} - {round(count / total_students, 3)}", end="")
            print()

            print("Question that most people answer incorrectly:", end=" ")
            for idx, (question, count) in enumerate(sorted_wrong):
                if count == max_wrong_count:
                    if idx > 0:
                        print(",", end=" ")
                    print(f"{question} - {count} - {round(count / total_students, 3)}", end="")
            print()

            file.close()

def Output_final():
    opened_files = []
    answer_key = "B,A,D,D,C,B,D,A,C,C,D,B,A,B,A,C,B,D,A,C,A,A,B,D,D"
    while True:
        for _ in range(8):
            while True:
                file_name = input("Enter a class file to grade (i.e. class1 for class1.txt): ")
                file_name_extra = './Data_Files/' + file_name + ".txt"
                try:
                    if file_name in opened_files:
                        print('This file has already been opened')
                        continue
                    else:
                        file = open(file_name_extra, 'r')
                except FileNotFoundError:
                    print(f"Error: File '{file_name_extra}' not found.")
                    continue
                else:
                    print(f"Successfully opened {file_name_extra}.txt")
                    opened_files.append(file_name)
                    break

            student_id = []
            grade = []
            lst_valid = []

            for line in file:
                lst_value = line.rstrip('\n').split(',')
                if len(lst_value) == 26 and lst_value[0][1:].isnumeric() and lst_value[0][0] == 'N' and len(lst_value[0]) != 9:
                    lst_valid.append(lst_value)

            for line in lst_valid:
                score = 0
                student_id.append(line[0])
                check_value = line[1:]
                for i in range(25):
                    if check_value[i] == '':
                        score += 0
                    elif check_value[i] == answer_key.split(',')[i]:
                        score += 4
                    else:
                        score -= 1
                # Ensure the score doesn't go below 0
                score = max(0, score)
                grade.append(score)

            file_name_extra = file_name_extra.rstrip('.txt')
            with open(file_name_extra+'_grade.txt', 'w') as fw:
                for stu_id, gr in zip(student_id, grade):
                    fw.write(stu_id + ',' + str(gr) + '\n')
                print(f'Successfully write file {file_name_extra}_grade.txt')
            file.close()









