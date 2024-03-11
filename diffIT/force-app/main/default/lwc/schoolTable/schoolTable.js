import { LightningElement, api, track, wire } from "lwc";
import findRecords from "@salesforce/apex/ContactFormController.findRecords";

export default class SchoolTable extends LightningElement {
  columns = [{ label: "Name", fieldName: "Name" }];
  @api institutions;
  @api objectApiName;
  @api coordinates;
  @track recordsList;
  @track filteredRecords = [];

  get doesRecordExists(){
    return this.filteredRecords.length != 0;
  }

  @wire(findRecords, {
    objectName: "$objectApiName",
    institutions: "$institutions",
    coordinates: "$coordinates"
  })
  getSchoolData({error,data}){
    if(data){
      this.recordsList = data;
      this.filteredRecords = [...this.recordsList];
    }
    if(error){
      console.error(error);
    }
  }
  
  handleSchoolSearch(event) {
    let searchString = event.target.value;
    this.filteredRecords = this.recordsList.filter((ele) => {
      return ele.Name?.toLowerCase().includes(searchString?.toLowerCase());
    });
  }
  getSelectedAccount(event) {
    const selectedRows = event.detail.selectedRows;
      const passEvent = new CustomEvent("recordselection", {
        detail: selectedRows[0]?.Id
      });
      this.dispatchEvent(passEvent);
  }
}
