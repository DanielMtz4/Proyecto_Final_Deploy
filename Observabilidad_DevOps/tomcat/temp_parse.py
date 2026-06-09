from pathlib import Path
import re
from html.parser import HTMLParser
text = Path('index.jsp').read_text(encoding='utf-8')
clean = re.sub(r'<%[^%]*%>', '', text, flags=re.S)
class MyParser(HTMLParser):
    def __init__(self):
        super().__init__(); self.stack=[]
    def handle_starttag(self, tag, attrs):
        if tag not in ('br','hr','img','input','meta','link','source','area','base','col','embed','param','track','wbr'): self.stack.append(tag)
    def handle_endtag(self, tag):
        if self.stack and self.stack[-1]==tag:
            self.stack.pop()
        else:
            print('mismatch end tag', tag, 'stack top', self.stack[-5:])
parser = MyParser(); parser.feed(clean); print('stack leftover', parser.stack[-10:])
