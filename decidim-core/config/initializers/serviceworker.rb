# frozen_string_literal: true

Rails.application.configure do
  config.serviceworker.routes.draw do
    match "/manifest.json"
    match "/serviceworker.js"
  end
end
