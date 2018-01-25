import React, {Component} from 'react';
import '../styles/NumericFiler.css'
import {Col, ControlLabel, FormGroup, HelpBlock} from "react-bootstrap";
import TextBox from "./TextBox";

class NumericFilter extends Component {
  constructor(...args) {
    super(...args);

    this.handleChange = this.handleChange.bind(this);
    this.renderFilterTextBox = this.renderFilterTextBox.bind(this);

    this.filterKeys = {
      min: 'min_' + this.props.id,
      max: 'max_' + this.props.id
    };

    this.filterNames = {
      min: 'Minimum ' + this.props.name,
      max: 'Maximum ' + this.props.name
    };

    this.state = {
      values: {
        min: this.parseValue(this.props.values.min),
        max: this.parseValue(this.props.values.max)
      },
      isValid: true
    };
  }

  parseValue(value) {
    return this.props.isMoney ? Number.parseFloat(value) : Number.parseInt(value, 10);
  }

  static isValid(values) {
    const minValue = values.min, maxValue = values.max;
    return (isNaN(minValue) || isNaN(maxValue) || minValue <= maxValue);
  }

  handleChange(filterType, newValue) {
    let state = {...this.state};
    state.values[filterType] = this.parseValue(newValue);
    state.isValid = NumericFilter.isValid(state.values);
    this.setState(state);
    this.props.handleChange(this.filterKeys[filterType], newValue, state.isValid);
  }

  validationState() {
    return this.state.isValid ? null : 'error';
  }

  valueForTextBox(filterType) {
    const value = this.state.values[filterType];
    return isNaN(value) ? '' : value;
  }

  renderFilterTextBox(filterType) {
    return <TextBox id={this.filterKeys[filterType]} value={this.valueForTextBox(filterType)}
                    name={this.filterNames[filterType]} type={filterType}
                    isMoney={this.props.isMoney} handleChange={this.handleChange}/>
  }

  renderError() {
    return this.state.isValid ? null : this.filterNames.min + ' can not be greater than ' + this.filterNames.max;
  }

  render() {

    return <FormGroup className={"text-box-group"}
                      controlId={this.props.id} validationState={this.validationState()}>
      <Col xs={12} sm={5} md={4} className={"label-container"}>
        <ControlLabel>{this.props.name} Range</ControlLabel>
      </Col>
      <Col xs={12} sm={7} md={7} lg={6} >
        {this.renderFilterTextBox('min')}
        {this.renderFilterTextBox('max')}
        <HelpBlock className={"validation-error"}>{this.renderError()}</HelpBlock>
      </Col>
    </FormGroup>;
  }
}

export default NumericFilter;