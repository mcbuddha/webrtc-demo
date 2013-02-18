[API, _, RTC] =
  [window._view = {},
  window._,
  window._rtc_helper]

API.info = ice:[],sdp:null
API.conn = null
API.chan = null

API.deliver = (offer_str) -> # deliver offer
  offer = RTC.read offer_str
  desc = RTC.new_desc on,type:'offer',sdp:offer.sdp
  API.conn.setRemoteDescription desc, (=>
    _.each offer.ice, (line) ->
      API.conn.addIceCandidate RTC.new_candidate line
  ),(RTC.err 'setremote')
  'delivered'

API.answer = ->
  API.conn.createAnswer ((desc) ->
    answer = RTC.new_desc off,desc
    API.conn.setLocalDescription answer, (=>
      API.info.sdp = RTC.tear answer.sdp
    ),(RTC.err 'setlocal')
  ),(RTC.err 'createanswer')
  'answered'

API.start = ->
  API.conn = RTC.new_conn()

  API.conn.onicecandidate = (e) ->
    API.info.ice.push e.candidate.candidate.trim() if e.candidate?

  API.conn.ondatachannel = (e) ->
    ___ 'opened chan'
    API.chan = e.channel
    API.chan.onopen = (f) -> ___ ['open', f]
    API.chan.onmessage = (f) -> ___ ['msg', f.data]
  'started'

API.ans = (offer_str) ->
  API.deliver offer_str
  setTimeout (-> ___ API.answer()), 1000
  setTimeout (-> ___ RTC.dump API.info), 1500


API.init = ->
  ___ 'init B'
  API.start()
