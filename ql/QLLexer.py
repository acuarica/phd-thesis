from pygments.lexer import RegexLexer, bygroups
from pygments.token import Name, Keyword, Text, Comment, String, Operator, Number

class QLLexer(RegexLexer):
    # name = 'QL'
    # aliases = ['ql']
    # filenames = ['*.ql']

    op = (u'[-~\\^\\*!%&\\\\<>\\|+=:/?@]+')
    letter = (u'[a-zA-Z\\$_]')
    upper = (u'[A-Z\\$_]')
    idrest = u'%s(?:%s|[0-9])*(?:(?<=_)%s)?' % (letter, letter, op)

    tokens = {
        'root': [
            (r'(class)(\s+)', bygroups(Keyword, Text), 'class'),
            (r'[^\S\n]+', Text),
            (r'//.*?\n', Comment.Single),
            (r'/\*', Comment.Multiline, 'comment'),
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
    }
