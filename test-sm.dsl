machine producer
  initially
    send out {t}
  end initially
end machine

machine consumer
  state idle : on in : dosomething
end machine

pipeline
  producer | consumer
end pipeline
