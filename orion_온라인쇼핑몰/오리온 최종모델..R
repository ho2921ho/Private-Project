library(rvest) 
library(httr)
library(yaml)
library(dplyr)
library(RCurl)
library(XML)

setwd(dir = 'C:/Users/renz/Desktop')
orion_table = read.csv('orion_table.csv')
for (i in 1:959){
  orion_table = rbind(orion_table,rep(1,64))
}

orion_table[] <- NA

# 전 작업.

orion_table$상품상태 = c('신상품')
orion_table$판매가 = final_dat$lprice
orion_table$카테고리ID = c('50004592')
orion_table$A.S.안내내용 = c('평일 오후 6시 이후 문의가능합니다. 주말은 종일 문의 가능합니다:)')
orion_table$재고수량 = c(9999)
orion_table$A.S.전화번호 = c('010-2220-6568')
orion_table$부가세 = c('과세상품')
orion_table$미성년자.구매 = c('Y')
orion_table$구매평.노출여부 = c('Y')
orion_table$원산지.코드 = c('0009680')
orion_table$복수원산지.여부 = c('N')
orion_table$배송방법 = c('택배‚ 소포‚ 등기')
orion_table$배송방법 = gsub("\U201A", ",", orion_table$배송방법)
orion_table$배송비.유형 = c('조건부 무료')
orion_table$조건부무료.상품판매가합계 = c(40000)
orion_table$기본배송비 = c(2500)
orion_table$배송비.결제방식 = c('선결제')
orion_table$반품배송비 = c(5000)
orion_table$교환배송비 = c(5000)
orion_table$스토어찜회원.전용여부 = c('N')


# 상품명 크롤링
# 이미지 크롤링
## branduid 크롤링

brandnames = NULL
scr_href = NULL
id_tag = NULL

for (i in 1:25){
print(i)
url = paste0('http://www.from-editors-b2b.com/shop/shopbrand.html?page=',i,'&xcode=002&mcode=&scode=&type=O&search=&sort=order')
html_editors = read_html(x = url, encoding = 'EUC-KR')
brandnames_temp = html_editors %>% html_nodes('.brandbrandname') %>% html_text() %>% data.frame(stringsAsFactors = F)
brandnames = rbind(brandnames,brandnames_temp)
html_image = html_editors %>% htmlParse() %>% capture.output

img_tag_pattern <- "<img src=\\\"/shopimages/editorsb2b/00.*?>"
img_tag <- html_image %>% regmatches(regexpr(img_tag_pattern, .))
src_href_pattern <- "(?<=src=\\\").*?(?=\\\")"
src_href_temp <- img_tag %>% regmatches(regexpr(src_href_pattern, ., perl=T)) %>% data.frame(stringsAsFactors = F)
scr_href = rbind(scr_href,src_href_temp)

html_branduid = html_editors %>% htmlParse() %>% capture.output
id_tag_pattern <- "<a href=\\\"/shop/shopdetail.*?>"
id_tag_temp <- html_branduid %>% regmatches(regexpr(id_tag_pattern, .)) %>% data.frame(stringsAsFactors = F)
id_tag = rbind(id_tag,id_tag_temp)
}

## 값 입력
orion_table$상품명 = brandnames
orion_table$상품명 = unlist(orion_table$상품명)


scr_href$. = paste0('http://www.from-editors-b2b.com',scr_href$.)
scr_href$image_name = gsub('http://www.from-editors-b2b.com/shopimages/editorsb2b/', '', x = scr_href$.)
scr_href$image_name = substr(scr_href$image_name, start = 1, stop = 17)
orion_table$대표.이미지.파일명 = scr_href[,2]

id_tag = unique(id_tag)
id_tag$. =regmatches(id_tag$., regexpr('[0-9]+',id_tag$.))
rownames(id_tag) <- c(1:964)
colnames(id_tag) <- 'branduid'
branduid = id_tag

# 이미지 다운로드
for(i in 1:nrow(scr_href)){
  download.file(scr_href[i,1], paste0("./orion/", scr_href[i,2]),mode="wb")
}



## 상세페이지 html 크롤링 
## 옵션 설정
# 옵션명 

detail_tag = NULL

option_name_dat = NULL

option_value_dat = NULL
option_type_dat = NULL

for (i in 1:964){
print(i)
# 상세페이지 크롤링.
url = paste0('http://www.from-editors-b2b.com/shop/shopdetail.html?branduid=', branduid[i,],'&xcode=002&mcode=000&scode=&type=O&search=&sort=order')
html_editors = read_html(x = url, encoding = 'EUC-KR')
html_detail = html_editors %>% htmlParse() %>% capture.output
detail_tag_pattern <- "<img.*esellersimg.co.kr.*"
detail_tag_temp <- html_detail %>% regmatches(regexpr(detail_tag_pattern, .)) %>% data.frame(stringsAsFactors = F)
detail_tag = rbind(detail_tag,detail_tag_temp)
# 옵션명 크롤링.
option_name = html_editors %>% html_nodes('.MK_tit') %>% html_text()
option_name_temp = paste(option_name, collapse = '\n') %>% data.frame(stringsAsFactors = F)
option_name_dat = rbind(option_name_dat,option_name_temp)
# 옵션값 크롤링.
option_value = html_editors %>% html_nodes('.MK_st option') %>% html_text()
if (length(option_value) == 0) {
option_type_temp = "입력형" %>% data.frame(stringsAsFactors = F)
option_type_dat = rbind(option_type_dat,option_type_temp)
option_value_temp = NA %>% data.frame(stringsAsFactors = F)
option_value_dat = rbind(option_value_dat,option_value_temp)
}
if (length(option_value) != 0) {
option_type_temp = "조합형" %>% data.frame(stringsAsFactors = F)
option_type_dat = rbind(option_type_dat,option_type_temp)
option_value_temp = paste(option_value[2:length(option_value)], collapse = ',')
option_value_temp = gsub(pattern = ",--옵션 선택--,",replacement =  '\n',option_value_temp) %>% data.frame(stringsAsFactors = F)
option_value_dat = rbind(option_value_dat,option_value_temp)   
}
}
orion_table$옵션형태 <- option_type_dat
orion_table$상품.상세정보 = detail_tag
## 크롤링 후처리
## 옵션명 통일

option_name_dat$. = gsub(pattern = '소재타입 선택', replacement = '케이스타입 선택', option_name_dat$. )
option_name_dat$. = gsub(pattern = '기종선택', replacement = '기종 선택', option_name_dat$. )
option_name_dat$. = gsub(pattern = '디자인타입 기재', replacement = '디자인이름 기재', option_name_dat$. )
option_name_dat$. = gsub(pattern = '\U00A0', replacement = '', option_name_dat$. )
option_name_dat$. = gsub(pattern = '슬림 or 슬라이드', replacement = '케이스타입 선택', option_name_dat$. )
option_name_dat_t = option_name_dat
orion_table$옵션명 <- option_name_dat_t

## 고리장식 선택 옵션과 케이스타입 선택 옵션을 추가상품으로 이동시키는 작업.
case_type_index = rep(NA,964) %>% data.frame(stringsAsFactors = F)
deco_index = rep(NA,964) %>% data.frame(stringsAsFactors = F)
add_goods1 = rep(NA,964) %>% data.frame(stringsAsFactors = F)
add_goods2 = rep(NA,964) %>% data.frame(stringsAsFactors = F)
add_goods = rep(NA,964) %>% data.frame(stringsAsFactors = F)
# 케이스타입을 이동.
for (i in 1:964){
  if (length((grep(pattern = "케이스타입 선택",option_name_dat_t[i,])))){
    option_name_dat_t[i,] = gsub('\n케이스타입 선택','',option_name_dat_t[i,])
    add_goods1[i,] <- "케이스타입(수량을 1로 해주세요)"
    case_type_index[i,] <- TRUE
  }
  else case_type_index[i,] <- FALSE 
}
# 고리장식 선택을 이동.
for (i in 1:964){
  if (length((grep(pattern = "고리장식 선택",option_name_dat_t[i,])))){
    option_name_dat_t[i,] = gsub('\n고리장식 선택','',option_name_dat_t[i,])
    add_goods2[i,] <- "고리장식(수량을 1로 해주세요)"
    deco_index[i,] <- TRUE
  }
  else deco_index[i,] <- FALSE 
}


for (i in 1:964){
add_goods[i,] = paste(add_goods1[i,],add_goods2[i,],sep = '\n')
add_goods[i,] = gsub("\nNA","",add_goods[i,])
add_goods[i,] = gsub("NA\n","",add_goods[i,])
add_goods[i,] = gsub("NA\nNA ","",add_goods[i,])
}
orion_table$추가상품명 <- add_goods
orion_table$옵션명 <- option_name_dat_t

### 불필요한 옵션값 제거

option_value_dat_t = option_value_dat
option_value_dat_t$.[1,] = gsub(pattern = ",선택안함", '',option_value_dat_t$.)
## 옵션재고수량.
option_value_dat_t$. = strsplit(x = option_value_dat_t$., split = '\n')
option_quan = rep(NA,964) %>% data.frame(stringsAsFactors = F)
for (i in 1:964){
n9999 = length(gregexpr(',',option_value_dat_t$.[i][[1]][1])[[1]])+1
option_quan[i,] <- paste(rep(9999,n9999),collapse = ',') 
}
orion_table$옵션.재고수량 = option_quan
## 안쓰는 옵션값 제거.
for(i in 1:964){
  
}
option_name_dat_g = option_name_dat


for (i in 1:964){
  print(i)
  option_name_dat_g$.[i] = strsplit(option_name_dat_g$.[i][[1]], split = '\n')
  index1 = grep(pattern = "케이스타입 선택", option_name_dat_g$.[i][[1]])
  index2 = grep(pattern = "고리장식 선택", option_name_dat_g$.[i][[1]])
  if (length(index1) != 0 | length(index1)!= 0){
  option_value_dat_t$.[i][[1]] = option_value_dat_t$.[i][[1]][c(-index1,-index2)]
  }
  option_value_dat_t$.[i] = paste(unlist(option_value_dat_t$.[i]),collapse = '\n')
}

orion_table$옵션값 = option_value_dat_t$.


## 추가옵션값 & 옵션가 & 재고수량
table(add_goods)
a_index1 = "케이스타입(수량을 1로 해주세요)\n고리장식(수량을 1로 해주세요)"
a_index2 = "케이스타입(수량을 1로 해주세요)"
a_index3 = "고리장식(수량을 1로 해주세요)"

add_goods_val = add_goods
add_goods_val[add_goods_val == a_index1,] <-"슬림,슬라이드(범퍼)\n고리장식부착,고리장식제거"
add_goods_val[add_goods_val == a_index2,] <-"슬림,슬라이드(범퍼)"
add_goods_val[add_goods_val == a_index3,] <-"고리장식부착,고리장식제거"
orion_table$추가상품값 <- add_goods_val$. 

add_goods_price = add_goods
add_goods_price[add_goods_price == a_index1,] <-'0,1500\n1000,0'
add_goods_price[add_goods_price == a_index2,] <-'0,1500'
add_goods_price[add_goods_price == a_index3,] <-'1000,0'
orion_table$추가상품가 <- add_goods_price$.
print(orion_table$추가상품가[100])
add_goods_quan = add_goods
add_goods_quan[add_goods_quan == a_index1,] <-"9999,9999\n9999,9999"
add_goods_quan[add_goods_quan == a_index2,] <-"9999,9999"
add_goods_quan[add_goods_quan == a_index3,] <-'9999,9999'
orion_table$추가상품.재고수량 <- add_goods_quan$.

###
orion_table$옵션값 = unlist(orion_table$옵션값)
orion_table$상품.상세정보 = unlist(orion_table$상품.상세정보)
orion_table$옵션형태 = unlist(orion_table$옵션형태)
orion_table$옵션명 = unlist(orion_table$옵션명)
orion_table$추가상품명 = unlist(orion_table$추가상품명)
orion_table$추가상품.재고수량 = unlist(orion_table$추가상품.재고수량)
orion_table$옵션.재고수량 = unlist(orion_table$옵션.재고수량)
## 'NA' > NA 

# 엑셀에서 하자...
## 문구방향 고치는 거도 엑셀에서 하구.. 옵션값 20자이하는 개수 봐서 엑셀에서 고치자.. 힘들어 .. 지겨워..이제 

# installing and loading readxl package 

install.packages('readxl')
install.packages('writexl')
library(readxl)
library(writexl)

write_xlsx(orion_table,path = 'orion_final_table3.xlsx' )

