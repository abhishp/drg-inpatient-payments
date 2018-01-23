import React, {Component} from 'react';
import '../styles/SearchForm.css';
import {Button, Col, Form, Grid, Row} from "react-bootstrap";
import NumericFilter from "./NumericFilter";
import StatesFilter from "./StatesFilter";
import APIClient from "../APIClient";

class SearchForm extends Component {
  constructor(...args) {
    super(...args);

    this.handleStateChange = this.handleStateChange.bind(this);
    this.handleNumericFilterChange = this.handleNumericFilterChange.bind(this);
    this.fetchResults = this.fetchResults.bind(this);
    this.renderNumericFilter = this.renderNumericFilter.bind(this);

    this.numericFilters = [
      {key: 'discharges', name: 'Total Discharges'},
      {key: 'average_covered_charges', name: 'Average Covered Charges', isMoney: true},
      {key: 'average_medicare_payments', name: 'Average Medicare Payments', isMoney: true},
      {key: 'average_total_payments', name: 'Average Total Payments', isMoney: true},
    ];

    this.state = {
      validity: {
        discharges: true,
        average_covered_charges: true,
        average_medicare_payments: true,
        average_total_payments: true
      },
      values: {
        state: this.props.filters.state,
        min_discharges: this.props.filters.min_discharges,
        max_discharges: this.props.filters.max_discharges,
        min_average_covered_charges: this.props.filters.min_average_covered_charges,
        max_average_covered_charges: this.props.filters.max_average_covered_charges,
        min_average_medicare_payments: this.props.filters.min_average_medicare_payments,
        max_average_medicare_payments: this.props.filters.max_average_medicare_payments,
        min_average_total_payments: this.props.filters.min_average_total_payments,
        max_average_total_payments: this.props.filters.max_average_total_payments
      }
    };
  }

  isValid() {
    return Object.values(this.state.validity).every(isValid => isValid);
  }

  handleStateChange(state) {
    this.setState({...this.state, state: state});
  }

  handleNumericFilterChange(key, value, isValid) {
    let state = {...this.state};
    state.values[key] = value;
    state.validity[key.replace(/min_|max_/)] = isValid;
    this.setState(state);
  }

  fetchResults(e) {
    e.preventDefault();
    if (!this.isValid()) {
      return;
    }
    const searchFilters = this.state.values;
    APIClient.getSearchResults(searchFilters, 1, (results, totalRecordCount, pageNumber, pageSize) => {
      this.props.showResults(searchFilters, results, totalRecordCount, pageSize);
    });
  }

  valuesForFilter(filterKey) {
    return {min: this.state.values['min_' + filterKey], max: this.state.values['max_' + filterKey]};
  }

  renderNumericFilter(filterSpecs) {
    return <NumericFilter
        key={filterSpecs.key} id={filterSpecs.key} values={this.valuesForFilter(filterSpecs.key)}
        name={filterSpecs.name} value={this.state.values[filterSpecs.key] || ''}
        handleChange={this.handleNumericFilterChange}
        isMoney={filterSpecs.isMoney}/>
  }

  render() {
    return (
        <Grid className={"search-form"} fluid>
          <Form horizontal itemID="search_form">
            <Row>
              <Col xs={12} md={12} lg={12}>
                <h2> Search </h2>
              </Col>
            </Row>
            <StatesFilter handleChange={this.handleStateChange}/>
            {this.numericFilters.map(this.renderNumericFilter)}
            <Row>
              <Col xs={12} md={4} lg={4} xsHidden/>
              <Col xs={12} md={2} lg={2}>
                <Button type="submit" bsStyle="primary" className={"search-submit"} onClick={this.fetchResults} disabled={!this.isValid()}>
                  Search
                </Button>
              </Col>
            </Row>
          </Form>
        </Grid>

    )
  }
}

export default SearchForm;