if Meteor.isClient
  if Package.ui
    Handlebars = Package.ui.Handlebars

  Handlebars.registerHelper 't9n', (x, prefix='') ->
    T9n.get(x, prefix)

  # backward compatibility with just-i18n, 
  Handlebars.registerHelper 'i18n', (x, prefix='') ->
    T9n.get(x, prefix)

class T9n

  @maps: {}
  @defaultLanguage: 'en'
  @language: ''
  @dep: new Deps.Dependency()
  
  @missingPrefix = ">"
  @missingPostfix = "<"
  
  @get: (x) ->
    @t9n x
    
  @map: (language, map) ->
    if(!@maps[language]) 
      @maps[language] = {}
    @registerMap(language, '', false, map)
    @dep.changed()

  @t9n: (label) ->
    @dep.depend()
    if typeof label != 'string' 
      return ''
    return (@maps[@language] && @maps[@language][label]) ||
      (@maps[@defaultLanguage] && @maps[@defaultLanguage][label]) ||
      @missingPrefix + label + @missingPostfix ||
      ''
    
  @registerMap = (language, prefix, dot, map) ->
    if typeof map == 'string' 
      @maps[language][prefix] = map
    else if typeof map == 'object'
      if dot 
        prefix = prefix + '.'
      for key, value of map
        @registerMap(language, prefix + key, true, value)        
        
@T9n = T9n

# this global function offers backward compatibility with just-i18n, 
# but it is born deprecated 
@i18n = (x) -> T9n.get(x)