package ismp

class CmOpRelation {

    String controllers
    String controllerName
    String actions
    String actionName
    static mapping = {
        id(generator: 'org.hibernate.id.enhanced.SequenceStyleGenerator', params: [sequence_name: 'seq_cm_oprelation', initial_value: 1])
    }
    static constraints = {
        controllers(unique: 'actions')
        controllerName(nullable: true)
        actionName(nullable: true)
    }
}
