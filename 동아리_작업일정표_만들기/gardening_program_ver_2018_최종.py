import string
import pandas as pd
import numpy

import string
import pandas as pd
import numpy

### 최소분산 구하기...
min_var_old_cand = []
min_var_new_cand = []
temp = 0

for i in range(1,101):

        
        gardening_data = open('gardening_data.txt', mode= 'r', encoding = 'ANSI').readlines()

        name = []

        isold = []

        date = []
        # 회원별 급수가능한 날짜를 담기 위해 빈리스트를 생성한다.


        ## 2단계 for문을 통해 리스트 채우기.

        import random

        pre_row_list = []
        for row in gardening_data:
            row = row.rstrip().split(',')
            pre_row_list.append((str(row)))
            random.shuffle(pre_row_list)
            
        row_list = []
        for i in pre_row_list:
            for t in string.punctuation:
                i = i.replace(t,'')
            i = i.split(' ')
            row_list.append(i)

            
        # 변환된 list를 활용해서 앞서 만든 빈 리스트들을 채운다.
        for line in row_list:
            name.append(line[0])
            # 이름 리스트에는 line의 인덱스가 0인 값만을 담아서 이름 명단이 채워지게 한다.
            isold.append(line[1])
            # 기존회원여부 리스트에는 line의 인덱스 1인 값만을 담아서 기존회원여부 리스트를 만든다.
            date.append(line[2:])
            # date에는 나머지 항목을 넣는다.

        ## 3단계 급수일자를 중복없이 빼오기
        unique_date = set()
        # 급수일자를 '중복없이' 빼오기 위해 빈 셋을 생성한다.
        for i in date:
            for j in i:
                unique_date.add(int(j))

        unique_date = list(unique_date)
        unique_date.sort()
        # 이중 for문을 통해 date에서 모든 항목을 뽑아놓고 set() 넣었다.
        # 정렬을 위해 list로 형을 변환했다. 


        ## 4단계 디폴트 딕셔너리에 값을 채워 넣기

        from collections import defaultdict
        # defaultdict 자료형을 이용해서 참조하려는 키가 없을 경우. 키를 생성하고
        # 값을 리스트 자료형으로 가질 수 있게 했다. 

        gardening_dict = defaultdict(list)
        # 디폴트 딕셔너리 만듬.
        # 최소분산을 구하자!!
        ## 4-1단계  기존회원과 하루만 가능한 사람들 처리
        for i, idi in enumerate(name):
            if isold[i] == '1' and len(date[i]) == 1:
            # 회원구분이 기존이고 하루밖에 가능하지 않을 때.
                gardening_dict[str(date[i]).strip('[]\'')].append(idi)
                # 디폴트 딕셔너리에 날짜로 키를 만들고 이름을 문자열 항목으로 담은 리스트를 값으로 대응시켰다.
            if isold[i] == '1' and len(date[i]) != 1:
            # 회원구분이 기존이고 여러날짜가 가능할 때.
                    for j in date[i]:
                        find = 0
                        if len(gardening_dict[j]) == 0:
                            gardening_dict[j] = [idi]
                            find += 1
                        if find == 1:
                            break
                    else:
                        min_candidate = []
                        for j in date[i]:
                            min_candidate.append(len(gardening_dict[j]))
                        min_date = min(min_candidate)
                        for k in date[i]:
                            if len(gardening_dict[k]) == min_date:
                                gardening_dict[k].append(idi)
                                break

        o_values = []
        for i in gardening_dict.values(): 
                o_values.append(len(i))
        
        o_var_values = round(numpy.var(o_values),6)
        min_var_old_cand.append(o_var_values)

        # 4-2 하루만 가능한 신입 회원의 처리
        for i, idj in enumerate(name):
         if isold[i] == '0' and len(date[i]) == 1:

                gardening_dict[str(date[i]).strip('[]\'')].append(idj)
                # 기존과 동일

        ## 4-3 단계 여러 날짜가 가능한 신입회원의 처리.


        for i, idx in enumerate(name):

            if isold[i] == '0' and len(date[i]) != 1:
            # 회원구분이 신입이이고 여러날짜가 가능할 때
                min_candidate = []
                for j in date[i]:
                    min_candidate.append(len(gardening_dict[j]))
                min_date = min(min_candidate)
                for k in date[i]:
                    if len(gardening_dict[k]) == min_date:
                        gardening_dict[k].append(idx)
                        break

        # 5단계 급수표를 수치화해서 최소분산 구하기.
        n_values = []
        for i in gardening_dict.values():
                n_values.append(len(i))
        
        n_var_values = numpy.var(n_values)
        min_var_new_cand.append(n_var_values)

min_var_old = min(min_var_old_cand)
min_var_new = min(min_var_new_cand)

while True:

        
        gardening_data = open('gardening_data.txt', mode= 'r', encoding = 'ANSI').readlines()

        name = []

        isold = []

        date = []
        # 회원별 급수가능한 날짜를 담기 위해 빈리스트를 생성한다.


        ## 2단계 for문을 통해 리스트 채우기.

        import random

        pre_row_list = []
        for row in gardening_data:
            row = row.rstrip().split(',')
            pre_row_list.append((str(row)))
            random.shuffle(pre_row_list)
            
        row_list = []
        for i in pre_row_list:
            for t in string.punctuation:
                i = i.replace(t,'')
            i = i.split(' ')
            row_list.append(i)

            
        # 변환된 list를 활용해서 앞서 만든 빈 리스트들을 채운다.
        for line in row_list:
            name.append(line[0])
            # 이름 리스트에는 line의 인덱스가 0인 값만을 담아서 이름 명단이 채워지게 한다.
            isold.append(line[1])
            # 기존회원여부 리스트에는 line의 인덱스 1인 값만을 담아서 기존회원여부 리스트를 만든다.
            date.append(line[2:])
            # date에는 나머지 항목을 넣는다.

        ## 3단계 급수일자를 중복없이 빼오기
        unique_date = set()
        # 급수일자를 '중복없이' 빼오기 위해 빈 셋을 생성한다.
        for i in date:
            for j in i:
                unique_date.add(int(j))

        unique_date = list(unique_date)
        unique_date.sort()
        # 이중 for문을 통해 date에서 모든 항목을 뽑아놓고 set() 넣었다.
        # 정렬을 위해 list로 형을 변환했다. 


        ## 4단계 디폴트 딕셔너리에 값을 채워 넣기

        from collections import defaultdict
        # defaultdict 자료형을 이용해서 참조하려는 키가 없을 경우. 키를 생성하고
        # 값을 리스트 자료형으로 가질 수 있게 했다. 

        gardening_dict = defaultdict(list)
        # 디폴트 딕셔너리 만듬.
        # 최소분산을 구하자!!
        ## 4-1단계  기존회원과 하루만 가능한 사람들 처리
        for i, idi in enumerate(name):
            if isold[i] == '1' and len(date[i]) == 1:
            # 회원구분이 기존이고 하루밖에 가능하지 않을 때.
                gardening_dict[str(date[i]).strip('[]\'')].append(idi)
                # 디폴트 딕셔너리에 날짜로 키를 만들고 이름을 문자열 항목으로 담은 리스트를 값으로 대응시켰다.
            if isold[i] == '1' and len(date[i]) != 1:
            # 회원구분이 기존이고 여러날짜가 가능할 때.
                    for j in date[i]:
                        find = 0
                        if len(gardening_dict[j]) == 0:
                            gardening_dict[j] = [idi]
                            find += 1
                        if find == 1:
                            break
                    else:
                        min_candidate = []
                        for j in date[i]:
                            min_candidate.append(len(gardening_dict[j]))
                        min_date = min(min_candidate)
                        for k in date[i]:
                            if len(gardening_dict[k]) == min_date:
                                gardening_dict[k].append(idi)
                                break

        values = []
        for i in gardening_dict.values(): 
                values.append(len(i))
        
        var_values = round(numpy.var(values),6)
        
        if not var_values == min_var_old:
            continue
        # 기존 회원의 분산이 최소일 때,  실행을 종료하고 다음으로 넘어가게 했음
        # 기존 회원의 고른 분포가 가능!

        # 4-2 하루만 가능한 신입 회원의 처리
        for i, idj in enumerate(name):
         if isold[i] == '0' and len(date[i]) == 1:

                gardening_dict[str(date[i]).strip('[]\'')].append(idj)
                # 기존과 동일

        ## 4-3 단계 여러 날짜가 가능한 신입회원의 처리.


        for i, idx in enumerate(name):

            if isold[i] == '0' and len(date[i]) != 1:
            # 회원구분이 신입이이고 여러날짜가 가능할 때
                min_candidate = []
                for j in date[i]:
                    min_candidate.append(len(gardening_dict[j]))
                min_date = min(min_candidate)
                for k in date[i]:
                    if len(gardening_dict[k]) == min_date:
                        gardening_dict[k].append(idx)
                        break

        # 5단계 급수표를 수치화해서 최소분산 구하기.
        values = []
        for i in gardening_dict.values():
                values.append(len(i))
        
        var_values = round(numpy.var(values),6)
        find = 0
        if var_values == min_var_new:
            find += 1
            for k in unique_date:
                print('{}일 급수자는 {}입니다.'.format(k,gardening_dict[str(k)]))
        if find == 1:
            break

        

