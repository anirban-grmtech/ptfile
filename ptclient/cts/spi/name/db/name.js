// For docs read ptclient/docs/models.md
import rowStatus from '@/cts/core/crud/rowstatus.js'

const { v1: uuidv1 } = require('uuid')

let count = 0
const intUniqueID = () => ++count

export default class reminders extends rowStatus {
  static entity = 'rem'

  static apiUrl = 'http://localhost:8000/reminders'

  static fields() {
    return {
      ...super.fields(),

      id: this.uid(() => intUniqueID()), // if this is not set then update based on primary key will not work
      uuid: this.uid(() => uuidv1()),
      firstName: this.string(null),
      middleName: this.string(''),
      lastName: this.string(null),
      recordChangedByUUID: this.string(null),
      recordChangedFromIPAddress: this.string(null),
      recordChangedFromSection: this.string(null),

      ROW_START: this.number(0),
      ROW_END: this.number(2147483647.999999), // this is unix_timestamp value from mariaDB for ROW_END when a record is created new in MariaDB system versioned table.
    }
  }
}
