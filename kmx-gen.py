
for x in range(1,537):
    print "#/bin/bash\nset -x\n"
    print "curl 'https://api.carmax.com/v1/api/vehicles?Distance=all&PerPage=100&SortKey=8&StartIndex="+str(x*100)+"&ExposedDimensions=249+250+1001+1000+265+999+772&ExposedCategories=249+250+1001+1000+265+999+772&Refinements=&Page="+str(x)+"&Zip=06512&platform=carmax.com&apikey=adfb3ba2-b212-411e-89e1-35adab91b600' -H 'origin: https://www.carmax.com' -H 'accept-encoding: gzip, deflate, br' -H 'accept-language: en-US,en;q=0.9' -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/64.0.3282.186 Safari/537.36' -H 'accept: application/json' -H 'referer: https://www.carmax.com/search' -H 'authority: api.carmax.com' -H 'cookie: KmxSession_0=logOdds=-2.503313784036&logOddsA=0.128848816&logOddsI=0.82764; check=true; AMCVS_0C1038B35278345B0A490D4C%40AdobeOrg=1; _ga=GA1.2.406402983.1520692383; _gid=GA1.2.389264421.1520692383; s_cc=true; __utmc=205652428; __utmz=205652428.1520692383.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); _ivu=1A2FD600-798E-4442-A16F-3318ABA12708; cto_lwid=537e0d02-21f6-4999-af6d-372f8963769b; AMCV_0C1038B35278345B0A490D4C%40AdobeOrg=-894706358%7CMCIDTS%7C17601%7CMCMID%7C73505821794959841203623337357014745419%7CMCAAMLH-1521297182%7C6%7CMCAAMB-1521310778%7CRKhpRz8krg2tLO6pguXWp5olkAcUniQYPHaMWWgdJ3xzPWQmdj0y%7CMCOPTOUT-1520713178s%7CNONE%7CMCAID%7C2CDBF31E0507EE06-60000105C0004858%7CMCSYNCSOP%7C411-17608%7CvVersion%7C2.3.0; ak_bmsc=CF6D2726B0794CFFB34053067EDB0FB6426E6426120D0000B821A45A12258E79~pldihPLLXhHGx8urQm0xJe7JfYBJvbUifzBywua6Vhe2pzQXKh3oyYVGP+oW1PD48GzVPe4iPGY+GP0R3qqHLQ20Dhln0D8i+qo+Cu5XP9Onhke21BoKpQRlTAI1MUBBU6MpdzXblnqwu8fEp7UWvqjY4y8YLeqUUNnwmnf+Ww18yoeIVUz7y9mCGQis1Vte8pIi/3akpIDaEnAmkAP0CZ5EDi/cBTVqOS2qcEbHIP02oBQqw8YUbgroh+02/3Tel6; __utma=205652428.406402983.1520692383.1520705978.1520711708.3; __utmt_9c5dead4ea5a3f406c80d66d0dad3d0e=1; s_sq=%5B%5BB%5D%5D; KmxVisitor_0=VisitorID=f7d319e7-c30a-4fdc-8762-be2a98876829&IsFirstVisit=False&Zip=06512&StoreId=7287&ZipDate=3/10/2018%208:15:25%20PM&ZipConfirmed=False&UsingStoreProxy=false&UserZip=null&sRadius=90; mbox=PC#3ae587a4f7bf4b6280f9b58c14bcc204.17_46#1583937184|session#488928b3951840f490da65f3b8111881#1520714787; KMXCOM_COOKIE=1746837770.30747.0000; _uetsid=_uet52159c6c; __utmb=205652428.5.10.1520711708; _gat=1; ADRUM_BT1=R:29|i:277464|e:144; ADRUM_BTa=R:29|g:d8327172-d0d6-420e-bf14-e4e2090e2f96|n:carmax-prod_e59f56d7-2fd4-4048-a02f-444092ecb532; bm_sv=8D23769E10EFE2F819FBB191012EADE6~7U2FfV9Jq0p0SXmUR4L2G7r5ugVH0TyZ743yIZJXPUZuHuYyvDuvV+oyHLyznoHIGmzuWMPYLN8FGfxILpdjuVRf3LJSdBPy1XZf8Dl/D6LiJK6u5xnArPWc4Ty/QnQKILqopJZkFJZnv3BMqjGxlm6s15cyzDkYUc4g7FiYlC8=; s_sess=%20s_ppvl%3DSearch%25253ASearch%252520Results%252C54%252C100%252C18837%252C1271%252C286%252C1280%252C800%252C2%252CL%3B%20s_ppv%3DSearch%25253ASearch%252520Results%252C25%252C100%252C8293%252C1271%252C286%252C1280%252C800%252C2%252CL%3B%20sc_v39%3D14ea479b-e130-42cb-aa24-129ee5fd9b7a%3B; s_pers=%20gpv_v4%3DSearch%253ASearch%2520Results%7C1520714775337%3B%20s_visit%3D1%7C1520714775347%3B' --compressed > kmx_" + str(x) + ".json"
    
 