import requests
import json
import pandas as pd 
def query_tsla(model='m3'):

    cookies = {
        'ak_bmsc': '481100A20B7706EEED9F661E57F5BBE9~000000000000000000000000000000~YAAQV0lyaE5h3pd9AQAAyyVS2A5opKeG2uQ7BP/sH8RtA47bUtKJQFzHwi9ZmGVkgPyUsQXCR1nm6U1bXT+nYUaSGMrTymsfv1IsAa99Dw2i8MyG+cHERr7H3QvEjWrDZVzyQ/p5iQV58rq92jdByeywumaXoE8tzzydQyA7lC7fMCCeCnp8XGZ7Sg2TMyRH48di3HRHxRs3N+YIJU+1iVhIAmbKVVThw2nRf/2LGrByIaDhqsVxYPDAIXMm6fqmn46ifYFBRqfZhBsXxxIceU/Xn5AlDGbMtNGdKjR3GsDTDrOt/yV4Y3g73qLfD7nJG4Fi06lfvDvHha5UqZrugxB7ARWz/9geaUZFhy40PpV0LZeBYjBLGTOaPs6kgqb7m3NtY7EMkwx3byYccy5tnh3IByQpNd+HtpoI14epnk7ABFM=',
        'bm_sv': '93A28B755FCD66A797FDFF4DBBDD8959~rfb4laShd4r9mth+3BwH7CMPBxmy5ky+L1Rz6DEG1eeB6ZQ3fxQ8NvqUeh3Brzh0FJcVItO+y9VBPIZsjcPvB+acdvZby5UVb5H1eWvOfXLB8o3UP7mL/AJJdpdeSQYvYN6yfGqLLgub7a2pamm+bqhd3D1TO6xl/N6viSkmZX4=',
        'ip_info': '{"ip":"3203:7000:2f03:c3f2:4a38:66b3:df7f:c3ee","location":{"latitude":32.731,"longitude":-91.822},"region":null,"city":"","country":"United States","countryCode":"US","postalCode":""}',
    }

    headers = {
        'User-Agent': 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:95.0) Gecko/20100101 Firefox/95.0',
        'Accept': '*/*',
        'Accept-Language': 'en-US,en;q=0.5',
        'Accept-Encoding': 'gzip, deflate, br',
        'Connection': 'keep-alive',
        'Referer': 'https://www.tesla.com/inventory/used/m3?arrangeby=plh&zip=',
        'Sec-Fetch-Dest': 'empty',
        'Sec-Fetch-Mode': 'cors',
        'Sec-Fetch-Site': 'same-origin',
        'Sec-GPC': '1',
        'If-None-Match': 'W/""1639790676-710968449""',
    }
    p_src = '{"query":{"model":"'+ model + '","condition":"used","options":{},"arrangeby":"Price","order":"asc","market":"US","language":"en","super_region":"north america"},"offset":0,"count":500,"outsideOffset":' 
    agg = []
    for i in range(0,5000,50):
        params = (
        ('query', p_src+str(i) + ',"outsideSearch":false}'),
    )
        response = requests.get('https://www.tesla.com/inventory/api/v1/inventory-results', headers=headers, params=params, cookies=cookies)
        jq = json.loads(response.text)
        agg.append(jq['results'])
        break
        if len(jq['results']) == 0:
            break

    with open(f"{model}_loc.json","w+") as f:
        json.dump(agg, f)


if __name__ == '__main__':
    models = ['m3','ms','mx','my']
    for model in models:
        query_tsla(model)