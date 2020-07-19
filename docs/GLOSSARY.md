### Glossary

- KIR: Keep it readable. "Programs are meant to be read by humans and only incidentally for computers to execute" - Donald Knuth
- KIL: Keep it local. Do not convert to functions without giving a good reason. Since 1. Each function call makes code hard to read 2. vue vuex-orm element.io all are giving lot of functions 3. A function should not have more than 2 paramters
- pt: Patient
- pts: Patients
- ct: Component
- cts: Components
- fn: Function
- pf: Patient file
- ctRem: Rem is a component
- pRem: Rem is a parameter to a function
- [ormRem](https://github.com/savantcare/ptfile/blob/5a821d5a7fb76bf4f41051319a6851f07474d1d2/ptclient/cts/spi/rem/vl/table.vue#L89): Rem is [ORM](https://en.wikipedia.org/wiki/Object-relational_mapping) created with [vuex-orm](https://vuex-orm.org/)
- mc: multi change
- c: change
- d: discontinue

### Data types

- sRem: variable of type string called Rem
- iRem: variable of type int called Rem
- bl: variable of type bool called Rem
- arRem: Array called Rem
- obRem: Object called Rem

### Component functions (similar to class functions)

In the following examples age is a function inside a component

- mfRem: method function
- wfRem: watch function
- cfRem: computed function
- mtfRem: Mutation function

### Component Prop (similar to function parameters)

- psRem: prop of type string called age in component.
- pnRem: prop of type number called age in the component
- paRem: prop of type array called age in the component
- poRem: prop of type object called age in the component

### Component Data (similar to local variables)

- dblRem: data of type boolean called age in the component
- dsRem: data of type string called age in the component.
- dnRem: data of type number called age in the component
- daRem: data of type array called age in the component
- doRem: data of type object called age in the component

### Component short forms

- dx: [Diagnosis](/ptclient/cts/spi/dx/)
- dxa: Diagnosis assessment
- g: goal
- [bm](https://github.com/savantcare/ptfile/tree/master/ptclient/cts/spi/bm): [Body measurement](/ptclient/cts/spi/bm/)
- [rec](https://github.com/savantcare/ptfile/tree/master/ptclient/cts/spi/rec): Recommendation
- recs: Recommendations
- [rem](https://github.com/savantcare/ptfile/tree/master/ptclient/cts/spi/rem): Reminder
- rems: Reminders
- sh: Social history. This is both plural and singular.
- mse: Mental status exam
- dob: Date of birth
- pros: Psych review of systems
- hx: History
- scr: screening

### Others

- VL: View layer ![Viw layer and change layer](./docs/images/vl-and-cl.png) In this diagram the layer at bottom
- CL: Change layer. In the above diagram the layer on top.
- cs: currrent state
- csvl: currrent state view layer ![multi state view layer and current state view layer](./docs/images/msvl-and-csvl.png). In this diagram it is on right
- ms: multi state
- msvl: multi state view layer. This has components that can show either the current state or historical state. In the above diagram it is on right
- timeOfStateSelectedInHeader: This gives the time for which : multiStateViewArea: should be rendered
- multiStateViewAreaHeader: This has the slider to choose : timeOfStateSelectedInHeader:
- pro: promise
- vst: vue state
- dec: description
- pi: patient info
- spi: seperate patient info. e,g, allergy is a spi. But feed that combines allergy with rec is not spi.

### Naming

- Files are folder names: All small case seperated by - For e.g. search-interfaces.vue. Why? some filesystems are case sensitive and some are not.

- Component names: camelCase
  - Why not use hyphens in component names?
    - If I do > import db-interaction from '../db-interaction'
      - The error will be:
      - Parsing error: Unexpected token
