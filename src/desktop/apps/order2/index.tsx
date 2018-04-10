import React from 'react'
import express from 'express'
import { App } from './Components/App'
import { renderLayout } from '@artsy/stitch'

const app = (module.exports = express())
app.set('view engine', 'jade')
app.set('views', `${__dirname}/Components`)

app.get('/order2', async (_req, res) => {
  try {
    const layout = await renderLayout({
      basePath: __dirname,
      layout: '../../components/main_layout/templates/react_index.jade',
      config: {
        styledComponents: true,
      },
      blocks: {
        head: () => <div>head</div>,
        body: App,
      },
      locals: {
        assetPackage: 'order2',
        ...res.locals,
      },
    })

    res.send(layout)
  } catch (error) {
    console.log('(apps/order2) Error: ', error)
  }
})