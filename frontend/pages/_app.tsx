import React from "react";
import App from "next/app";
import { withApplicationInsights } from 'next-applicationinsights';

class MyApp extends App {
  render() {
    const { Component, pageProps } = this.props

    return (

      <Component {...pageProps} />
    )
  }
}

export default withApplicationInsights({
  instrumentationKey: '0b902312-dbaa-4ac0-bd21-029752baeb37',
  isEnabled: true //process.env.NODE_ENV === 'production'
})(MyApp)
