import React, {Component} from 'react';
import {Col, Table} from "react-bootstrap";
import '../styles/SearchResultsForSmallDevice.css'

class SearchResultsForSmallDevice extends Component {
  render() {
    return (
        <Col xs={12} mdHidden lgHidden>
          {this.props.results.map((result, index) => {
            return <Table bordered condensed striped key={'searchResultForSmallDevice' + index}
                          className={"search-result-for-small-device"}>
              <tbody>
              <tr>
                <td colSpan={2} className={"provider-name"}>{result.providerName}</td>
              </tr>
              <tr>
                <td className={"total-discharges"}>{result.totalDischarges}</td>
                <td className={"average-covered-charges"}>${result.averageCoveredCharges}</td>
              </tr>
              <tr>
                <td className={"average-medicare-payments"}>${result.averageMedicarePayments}</td>
                <td className={"average-total-payments"}>${result.averageTotalPayments}</td>
              </tr>
              </tbody>
            </Table>
          })}
        </Col>
    )
  }
}

export default SearchResultsForSmallDevice;