import React, {Component} from 'react';
import {Col, FormControl, InputGroup} from "react-bootstrap";
import '../styles/TextBox.css'

class TextBox extends Component {
  constructor(...args) {
    super(...args);

    this.handleChange = this.handleChange.bind(this);
    this.handleKeyPress = this.handleKeyPress.bind(this);

    this.state = {
      value: this.props.value
    }
  }

  static removeTextValues(text) {
    if (!text) return '';
    let numericRegex = new RegExp('\\d+|\\.', 'g');
    let matches = text.match(numericRegex);
    if (!matches) return '';
    let firstDecimalIndex = matches.indexOf('.');
    let nextDecimalIndex = -1;
    do {
      nextDecimalIndex = matches.indexOf('.', firstDecimalIndex + 1);
      if (nextDecimalIndex > 0) matches.splice(nextDecimalIndex, 1);
    } while (nextDecimalIndex !== -1);
    return matches.join('');
  }

  handleChange(e) {
    let newValue = TextBox.removeTextValues(e.target.value);

    this.setState({value: newValue});
    this.props.handleChange(this.props.type, newValue);
  }

  handleKeyPress(e) {
    const key = e.key;
    if (!((key >= '0' && key <= '9') || (this.props.isMoney && key === '.'))) {
      e.preventDefault();
    }
  }

  render() {
    let inputBox = <FormControl
        type="text"
        value={this.state.value}
        placeholder={this.props.name}
        onChange={this.handleChange}
        onKeyPress={this.handleKeyPress}/>;

    let textBoxElement = inputBox;
    if (this.props.isMoney) {
      textBoxElement = <InputGroup>
        <FormControl.Feedback className={"text-box-feedback"}/>
        <InputGroup.Addon>$</InputGroup.Addon>
        {inputBox}
      </InputGroup>
    }

    return <Col xs={12} sm={6}>
      {textBoxElement}
    </Col>
  }
}

export default TextBox;