# 도매몰에서 판매하고 있는 모든 케이스 이름을 크롤링.
library(httr)
library(rvest)


name_list = NULL

for (i in 1:25)
{
url_case = paste0('http://www.from-editors-b2b.com/shop/shopbrand.html?page=',i,'&xcode=002&mcode=&scode=&type=O&search=&sort=order')
html_case = read_html(x = url_case,encoding = 'euc-kr')
name = html_case %>% html_nodes(".brandbrandname") %>% html_text()
name = data.frame(name,stringsAsFactors = F)
name_list = rbind(name_list,name)
}

# name_list에서 불필요한 부분제거. 검색이 잘 안되는 경우를 막기위해서!

name_list$name = gsub('\\[다양한기종\\]',' ',name_list$name)
name_list$name = gsub('/',' ',name_list$name)
name_list$name = gsub('핸드메이드',' ',name_list$name)
name_list$name = gsub('키링',' ',name_list$name)
name_list$name = gsub('스트랩',' ',name_list$name)
name_list$name = gsub('케이스',' ',name_list$name)
name_list$name = gsub('핑크리본',' ',name_list$name)
name_list$name = gsub('데코',' ',name_list$name)
name_list$name = gsub('고리',' ',name_list$name)
name_list$name = gsub('스터드',' ',name_list$name)
name_list$name = gsub('glossy',' ',name_list$name)
name_list$name = gsub('장식',' ',name_list$name)
name_list$name = gsub('스타일',' ',name_list$name)
name_list$name = gsub('시리즈',' ',name_list$name)
name_list$name = gsub('일러스트',' ',name_list$name)
name_list$name = gsub('케이스',' ',name_list$name)
name_list$name = gsub('\\[문구제작\\]',' ',name_list$name)
# 네이버 API 쇼핑을 통해 각 케이스의 최저가를 검색.
client_id = 'TDV9SKiDKC8Ltxdtmk4D';
client_secret = 'QHVlFl9Hp5';
header = httr::add_headers(
  'X-Naver-Client-Id' = client_id,
  'X-Naver-Client-Secret' = client_secret)

end_num = nrow(name_list)
display_num = 10
start_point = seq(1,end_num,display_num) 
end_point = seq(10,end_num,display_num)
end_point = append(end_point,end_num)


final_dat = NULL
for (i in 1:length(start_point)){
for (j in start_point[i]:end_point[i])
{query = name_list[j,]
print(j)
date_time<-Sys.time()
while((as.numeric(Sys.time()) - as.numeric(date_time))<0.06)
query = URLencode(query)
url = paste0('https://openapi.naver.com/v1/search/shop.xml?query=',query,'&display=',display_num = 1,'&start=',1,'&sort=asc')
url_body = read_xml(GET(url, header), encoding = "UTF-8")


title = url_body %>% xml_nodes('item title') %>% xml_text()
lprice = url_body %>% xml_nodes('item lprice') %>% xml_text()
mallName = url_body %>% xml_nodes('item mallName') %>% xml_text()
temp_dat = cbind(title, lprice, mallName)
final_dat = rbind(final_dat, temp_dat)
cat(j, '\n')
if (length(title) == 0){
  final_dat = rbind(final_dat,c(name_list[j,],NA,NA))
}

}}

final_dat = data.frame(final_dat, stringsAsFactors = F)
final_dat$lprice = as.numeric(final_dat$lprice)
final_dat$search_name = name_list$name
final_dat$real_name = brandnames$.


# 이상치 처리1 NA값
sum(is.na(final_dat$lprice))
final_dat$lprice[is.na(final_dat$lprice)] <- 12850

# 이상치 처리2 이상값
length(which(final_dat$lprice > 24000))
final_dat$lprice[final_dat$lprice > 24000 & is.finite(final_dat$lprice)] <- 12850

# 이상치 처리3 이하값

length(which(final_dat$lprice < 12000))
final_dat$lprice[final_dat$lprice < 12000 & is.finite(final_dat$lprice)] <- 12850
## 12850을 가격으로 정한다.

### 판매가 갱신

table(final_dat$lprice)

final_dat$lprice[final_dat$lprice < 15600 ] <- final_dat$lprice[final_dat$lprice < 15600 ] - c(600)

final_dat$lprice[final_dat$lprice > 15600 & final_dat$lprice < 17700] <- 
  final_dat$lprice[final_dat$lprice > 15600 & final_dat$lprice < 17700] - c(1000)

final_dat$lprice[final_dat$lprice > 17700] <- 
  final_dat$lprice[final_dat$lprice > 17700] - c(1500)
