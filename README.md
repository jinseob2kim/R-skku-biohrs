# R-skku-biohrs
R lecture: SKKU-biohrs

성균관대학교 바이오헬스규제과학과 강의


## 목표

R 은 단순한 통계프로그램이 아닌 데이터분석 전 과정을 포함하는 플랫폼이다. 본 강의는 **data.table** /**magrittr** 패키지 중심으로 빅데이터 매니지먼트를, 자체 패키지로 흔히 쓰는 통계를, **rmarkdown/shiny** 로 다양한 분석결과 정리법(문서, 슬라이드, 웹앱) 을 다룬다. 모든 예시는 심평원/보험공단/국민건강영양조사 데이터를 이용, 학생들은 바로 공공빅데이터 연구를 시작할 수 있다. 실습코드를 개인 github 저장소에서 관리, 오픈소스 생태계에 익숙해지면서 R 패키지까지 만들 수 있길 기대한다.  


## 강사 이력 

이름: [김진섭](https://jinseob2kim.github.io/resume/)

소속: 연구지원법인 [차라투](https://www.zarathu.com) 대표

학력: 성균관의대 졸업, [서울대학교 보건대학원](http://snugepi.snu.ac.kr/) 박사 수료.
      
주요 경력: 

 - [예방의학 전문의(서울대 보건대학원)](http://snu-prev.com/), 
 - [책임연구원(삼성전자 무선사업부)](https://news.samsung.com/kr/%EC%97%85%EB%AC%B4%EA%B0%80-%EC%9E%A0%EC%9E%90%EA%B8%B0%EC%97%AC%EC%84%9C-%EC%A2%8B%EA%B2%A0%EB%8B%A4%EA%B3%A0%EC%9A%94-s%ED%97%AC%EC%8A%A4-%EA%B0%9C%EB%B0%9C%EC%A7%84), 
 - R패키지 개발([jskm](https://CRAN.R-project.org/package=jskm), [jstable](https://CRAN.R-project.org/package=jstable), [jsmodule](https://CRAN.R-project.org/package=jsmodule)),  
 - R 개발자 커뮤니티 [Shinykorea](https://github.com/Shinykorea) 후원 및 운영
 - [SW마에스트로](https://www.swmaestro.org/sw/main/main.do) 멘토

온라인 조교: [이건희](lisalee1208@naver.com)


## 일정 

일시: 매주 화요일 19-21시

|회차| 날짜  | 주제  |
|---|---|---|
|1| 8월 30일  | 강의계획안내, [깃허브(github)](code/github.R), [공공의료빅데이터 소개](lecture/공단데이터소개.pdf)  |
|2| 9월 6일  | R 데이터 매니지먼트 [base](https://blog.zarathu.com/posts/2020-02-16-rdatamanagement-basic), [code](code/base.R)  |
|3|  9월 13일|  R 데이터 매니지먼트 최근: [tidyverse](https://jinseob2kim.github.io/lecture-snuhlab/tidyverse) |
|4|   9월 20일| R 데이터 매니지먼트: [data.table](https://blog.zarathu.com/posts/2022-02-11-datatable/), [code](code/datatable.R)  |
|5|  9월 27일 | R 데이터 매니지먼트: [data.table 실전](code/)  |
|6|  10월 4일| R 데이터 시각화: [강의록](https://blog.zarathu.com/posts/2022-03-25-graph/), [code](code/plot/), [ggplot2 참고자료](https://evamaerey.github.io/ggplot_flipbook/ggplot_flipbook_xaringan.html)  |
|7|  10월 11일| 기초통계이론: 확률(Probability) vs 가능도(Likelihood)([강의록](https://rpubs.com/Statdoc/204928), [슬라이드](https://jinseob2kim.github.io/R-skku-biohrs/likelihood)), 정규분포([강의록](https://rpubs.com/Statdoc/204929), [슬라이드](https://jinseob2kim.github.io/R-skku-biohrs/normal_Distribution))|
|8|  10월 18일| 중간고사 |
|9|  10월 25일| R 통계(1): [의학연구에서의 기술통계](https://blog.zarathu.com/posts/2020-07-08-table1inmed/), [code](code/descriptive.R), [tableone 소개](https://blog.zarathu.com/posts/2022-02-07-tableone/),  [gtsummary 소개](https://blog.zarathu.com/posts/2022-02-07-gtsummary/) |
|10|  11월 1일| R 통계(2): [회귀분석, 생존분석](https://blog.zarathu.com/posts/2020-07-22-regressionbasic/), [생존분석 추가자료](https://blog.zarathu.com/posts/2020-10-29-survivalpractice/), [리뷰어 위한 의학통계](https://jinseob2kim.github.io/lecture-general/statreview/#59)  |
|11|  11월 8일| R 통계(3): [비선형모형: GAM](https://jinseob2kim.github.io/R-skku-biohrs/gam), [성향점수 매칭, 가중치](code/table1_ps.R), [국건영데이터 소개](https://knhanes.kdca.go.kr/knhanes/sub03/sub03_01.do), [code](code/KNHANES.R) |
|12|  11월 15일| R로 보고서쓰기: [Rmarkdown](https://blog.zarathu.com/posts/2019-01-03-rmarkdown/), [엑셀, ppt로 저장하기](lecture/dataexport.pptx) |
|13|  11월 22일| R로 웹앱 만들기: [Shiny 소개](https://github.com/jinseob2kim/shiny-workshop-odsc2019) |
|14|  11월 29일| [R 패키지 만들기](https://github.com/jinseob2kim/RTHON2020) |
|15|  12월 6일| [기말고사](https://jinseob2kim.github.io/finalexam/finalexam.html) |

## 특강
|1| 22.07.15 & 11.16| [데이터과학자가 갖춰야할 기술: 규제과학과 단기 교육](https://jinseob2kim.github.io/R-skku-biohrs/short-2022summer) |


## 준비사항 

개인 PC에서 실습을 원한다면 http://www.r-project.org 와 https://rstudio.com/products/rstudio/download/#download 에서 **[R](https://www.r-project.org/)** 과 **[RStudio](https://rstudio.com/)** 를 설치하자.

클라우드 환경인 [RStudio cloud](https://rstudio.cloud) 에서도 가능하며, 회원가입 후 아래를 따라 강의자료가 포함된 실습환경을 생성하자.


> 1. https://rstudio.cloud 회원 가입

> 2. 위쪽 __*"Projects"*__ 클릭 후, __*"New Project"*__ 를 눌러 __*"New Project from Git Repo"*__ 를 선택 후, Repo 주소 **https://github.com/jinseob2kim/R-skku-biohrs** 입력.



**[실습데이터 및 설명자료 다운로드](https://1drv.ms/u/s!AvwFxLQIpBXdhf0B_wedH9jP7D6sHg?e=YXzS0e)**

[심평원 약품성분명코드](https://www.data.go.kr/data/15067461/fileData.do)

아래 패키지들을 미리 설치하면 좋다.

```r
install.packages(c("data.table", "magrittr", "fst", "ggplot2", "ggpubr", "officer", "rvg", "tableone", "gtsummary", "MatchIt", "twang", "usethis", "gitcreds"))
```
