[API, _, RTC] =
  [window._view = {},
  window._,
  window._rtc_helper]

API.info = ice:[],sdp:null
API.conn = null
API.chan = null

API.deliver = (answer_str) -> # deliver peer answer
  answer = RTC.read answer_str
  desc = RTC.new_desc on,type:'answer',sdp:answer.sdp
  API.conn.setRemoteDescription desc, (=>
    _.each answer.ice, (line) ->
      API.conn.addIceCandidate RTC.new_candidate line
  ),(RTC.err 'setremote')
  'delivered'

API.offer = ->
  API.conn = RTC.new_conn()
  API.conn.onicecandidate = (e) -> API.info.ice.push e.candidate.candidate.trim()

  API.chan = API.conn.createDataChannel 'chan_label',reliable:off
  API.chan.onopen = ->
    ___ ['opened chan',arguments]
    API.chan.send 'hello chan'
  API.chan.onmessage = (e) -> ___ ['msg',e.data]

  API.conn.createOffer ((desc) =>
    offer = RTC.new_desc off,desc
    API.conn.setLocalDescription offer, (=>
      API.info.sdp = RTC.tear offer.sdp
    ),(RTC.err 'setlocal')
  ),(RTC.err 'createoffer')
  'offered'


API.init = ->
  ___ 'init A'
  ___ API.offer()
  setTimeout (-> ___ RTC.dump API.info), 1000