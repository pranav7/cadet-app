import {Container, Icon} from "semantic-ui-react";
import React, { Component, useState } from "react";

export function Loader({ containerClassName }) {
  const containerClass = containerClassName || "m-4 text-center";
  return (<Container className={containerClass}>
    <Icon loading name="circle notch" size="large" color="grey" />
  </Container>)
}