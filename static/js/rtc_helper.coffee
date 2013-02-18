window.___ = (x) -> console.log x
[API, B64] =
  [window._rtc_helper = {},
  window.Base64]

NAT = iceServers: []#[{url:"stun:stun.l.google.com:19302"}]
RTP = optional: [{RtpDataChannels:on}]

API.read = (b64) -> JSON.parse B64.decode b64
API.dump = (o) -> B64.encode JSON.stringify o

API.new_conn = -> new webkitRTCPeerConnection NAT,RTP

API.new_candidate = (line) ->
  new RTCIceCandidate sdpMLineIndex:0,sdpMid:'data',candidate:line+'\n'

API.new_desc = (torn,{type:t,sdp:s}) ->
  new RTCSessionDescription type:t,sdp:(helpdesc s,torn)

API.err = (tag) => (e) -> ___ ['error',tag,e]
API.ok = (v) -> ___ ['ok', v]

API.tear = (s) -> _.map (s.split '\n'), (l) -> l.trim()
helpdesc = (full_sdp,torn=off) -> # remove unused sdp info
  sdp = if torn then full_sdp else API.tear full_sdp
  a = sdp.indexOf _.find sdp, (l) -> l[0..6] is 'm=audio'
  if a is -1
    return if torn
      full_sdp.join '\n'
    else
      full_sdp    
  b = sdp.indexOf _.find sdp[a+1..-1], (l) -> l[0] is 'm'
  c = sdp.indexOf _.find sdp, (l) -> l[0] is 'a'
  sdp[c] = 'a=group:BUNDLE data'
  (sdp[0..a-1].concat sdp[b..-1]).join '\n'
