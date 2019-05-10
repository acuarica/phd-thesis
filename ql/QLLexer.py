from pygments.lexer import * #RegexLexer
from pygments.token import * 
#Name, Keyword, bygroups
from pygments.lexers.jvm import ScalaLexer

class QLLexer(RegexLexer):
    name = 'QL'
    aliases = ['ql']
    filenames = ['*.ql']

    # EXTRA_KEYWORDS = set(('from', 'where', 'select', 'and', 'or', 'not', 'instanceof', 'predicate'))
    # EXTRA_PSEUDO = set(('result'))
    # EXTRA_FUNCTIONS = set(('exists', 'count'))
    # REMOVE_KEYWORDS = set(('asdf', 'def'))

    # def get_tokens_unprocessed(self, text):
    #     for index, token, value in ScalaLexer.get_tokens_unprocessed(self, text):
    #         if token is Name and value in self.EXTRA_KEYWORDS:
    #             yield index, Keyword, value
    #         elif token is Name and value in self.EXTRA_PSEUDO:
    #             yield index, Keyword.Pseudo, value
    #         elif token is Name and value in self.EXTRA_FUNCTIONS:
    #             yield index, Name.Function.Magic, value
    #         elif token is Keyword and value in self.REMOVE_KEYWORDS:
    #             yield index, Name, value
    #         else:
    #             yield index, token, value

    # don't use raw unicode strings!
    op = (u'[-~\\^\\*!%&\\\\<>\\|+=:/?@]+')
    letter = (u'[a-zA-Z\\$_]')
    upper = (u'[A-Z\\$_]')
    idrest = u'%s(?:%s|[0-9])*(?:(?<=_)%s)?' % (letter, letter, op)
    letter_letter_digit = u'%s(?:%s|\\d)*' % (letter, letter)

    tokens = {
        'root': [
            # method names
            (r'(class)(\s+)', bygroups(Keyword, Text), 'class'),
            (r'[^\S\n]+', Text),
            (r'//.*?\n', Comment.Single),
            (r'/\*', Comment.Multiline, 'comment'),
            # (u'@%s' % idrest, Name.Decorator),
            (u'(abstract|private|class|extends|predicate|instanceof|and|or|not)\\b', Keyword),
            (u'(select|from|where)\\b', Keyword.Reserved),
            (u'(this|result)\\b', Keyword.Pseudo),
            (u'(count|exists|forall|forex)\\b', Name.Builtin),
            (u'%s%s\\b' % (upper, idrest), Name.Function),
            (r'(true|false|null)\b', Keyword.Constant),
            (r'(import)(\s+)', bygroups(Keyword, Text), 'import'),
            (r'""".*?"""(?!")', String),
            (r'"(\\\\|\\"|[^"])*"', String),
            (r"'\\.'|'[^\\]'|'\\u[0-9a-fA-F]{4}'", String.Char),
            (u"'%s" % idrest, Text.Symbol),
            (idrest, Name),
            (r'`[^`]+`', Name),
            (r'[(){};,.#]', Operator),
            (op, Operator),
            # (r'([0-9][0-9]*\.[0-9]*|\.[0-9]+)([eE][+-]?[0-9]+)?[fFdD]?', Number.Float),
            # (r'0x[0-9a-fA-F]+', Number.Hex),
            (r'[0-9]+L?', Number.Integer),
            (r'\n', Text)
        ],
        'class': [
            (u'(%s|%s|`[^`]+`)(\\s*)(\\[)' % (idrest, op),
             bygroups(Name.Class, Text, Operator), 'typeparam'),
            (r'\s+', Text),
            (r'\{', Operator, '#pop'),
            (r'\(', Operator, '#pop'),
            (r'//.*?\n', Comment.Single, '#pop'),
            (u'%s|%s|`[^`]+`' % (idrest, op), Name.Class, '#pop'),
        ],
        # 'type': [
        #     (r'\s+', Text),
        #     (r'<[%:]|>:|[#_]|forSome|type', Keyword),
        #     (u'([,);}]|=>|=|\u21d2)(\\s*)', bygroups(Operator, Text), '#pop'),
        #     (r'[({]', Operator, '#push'),
        #     (u'((?:%s|%s|`[^`]+`)(?:\\.(?:%s|%s|`[^`]+`))*)(\\s*)(\\[)' %
        #      (idrest, op, idrest, op),
        #      bygroups(Keyword.Type, Text, Operator), ('#pop', 'typeparam')),
        #     (u'((?:%s|%s|`[^`]+`)(?:\\.(?:%s|%s|`[^`]+`))*)(\\s*)$' %
        #      (idrest, op, idrest, op),
        #      bygroups(Keyword.Type, Text), '#pop'),
        #     (r'//.*?\n', Comment.Single, '#pop'),
        #     (u'\\.|%s|%s|`[^`]+`' % (idrest, op), Keyword.Type)
        # ],
        'typeparam': [
            (r'[\s,]+', Text),
            (u'<[%:]|=>|>:|[#_\u21D2]|forSome|type', Keyword),
            (r'([\])}])', Operator, '#pop'),
            (r'[(\[{]', Operator, '#push'),
            (u'\\.|%s|%s|`[^`]+`' % (idrest, op), Keyword.Type)
        ],
        'comment': [
            (r'[^/*]+', Comment.Multiline),
            (r'/\*', Comment.Multiline, '#push'),
            (r'\*/', Comment.Multiline, '#pop'),
            (r'[*/]', Comment.Multiline)
        ],
        'import': [
            (u'(%s|\\.)+' % idrest, Name.Namespace, '#pop')
        ],
        # 'interpbrace': [
        #     (r'\}', String.Interpol, '#pop'),
        #     (r'\{', String.Interpol, '#push'),
        #     include('root'),
        # ],
    }
