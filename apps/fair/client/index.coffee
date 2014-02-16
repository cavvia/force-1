Backbone          = require 'backbone'
sd                = require('sharify').data
SearchBarView     = require '../../../components/search_bar/view.coffee'
Profile           = require '../../../models/profile.coffee'
Fair              = require '../../../models/fair.coffee'
FairInfoView      = require './info.coffee'
FairPostsView     = require './posts.coffee'
FairSearchView    = require './search.coffee'
ForYouView        = require './for_you.coffee'
FairBrowseRouter  = require './browse.coffee'
OverviewView      = require './overview.coffee'
analytics         = require '../../../lib/analytics.coffee'
FavoritesView     = require('../../favorites_follows/client/favorites.coffee').FavoritesView
FollowsView       = require('../../favorites_follows/client/follows.coffee').FollowsView

module.exports.FairView = class FairView extends Backbone.View

  sectionHash:
    info      : FairInfoView
    posts     : FairPostsView
    search    : FairSearchView
    browse    : FairBrowseRouter
    favorites : FavoritesView
    follows   : FollowsView
    forYou    : ForYouView
    overview  : OverviewView

  initialize: (options) ->
    @fair = options.fair
    @setupSearch @model, @fair

    if @sectionHash[options.currentSection]
      el = if options.currentSection == 'overview' then @$el else @$('.fair-page-content')
      new @sectionHash[options.currentSection]
        model: @model
        fair : @fair
        el   : el

      if options.currentSection == 'follows' or options.currentSection == 'favorites'
        @fixFavoritesFollowingTabs @model

  # Kinda hacky
  fixFavoritesFollowingTabs: (profile) ->
    @$('.follows-tabs.garamond-tablist a').each ->
      $(@).attr href: "#{profile.href()}#{$(@).attr('href')}"

  setupSearch: (profile, fair) ->
    @searchBarView ||= new SearchBarView
      el     : @$('#fair-search-container')
      $input : @$('#fair-search-input')
      fairId : @fair.get('id')
    @searchBarView.on 'search:entered', (term) => window.location = "#{@model.href()}/search?q=#{term}"
    @searchBarView.on 'search:selected', (e, model) ->
      return false unless model
      model.updateForFair fair
      analytics.track.click "Selected item from fair search", { label: analytics.modelNameAndIdToLabel(model.get('display_model'), model.get('id')), query: @query }
      @selected = true
      window.location = model.get('location')

module.exports.init = ->
  new FairView
    model: new Profile sd.PROFILE
    fair : new Fair sd.FAIR
    el   : $('#fair-page')
    currentSection: sd.SECTION
