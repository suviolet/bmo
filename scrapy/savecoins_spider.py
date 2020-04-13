import json
import urllib.parse
from urllib.parse import unquote

from scrapy import Request, Spider


class SaveCoinsSpider(Spider):
    name = 'savecoins_nintendo'
    site = 'SaveCoins'
    domain = 'https://api-savecoins.nznweb.com.br/v1/games'
    games_params = (
        '?filter[platform]=nintendo&currency=BRL'
        '&locale=pt&page[size]=20&page[number]=1'
    )

    def start_requests(self):
        yield Request(
            self.domain + self.games_params,
            callback=self.parse_page
        )

    def parse_page(self, response):
        pass
