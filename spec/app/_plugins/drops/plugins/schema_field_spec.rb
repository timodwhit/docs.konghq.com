RSpec.describe Jekyll::Drops::Plugins::SchemaField do
  let(:name) { 'config' }
  let(:parent) { '' }
  let(:field_schema) { schema.config }
  let(:schema) do
    PluginSingleSource::Plugin::Schemas::Kong.new(
      plugin_name: 'saml',
      vendor: 'kong-inc',
      version: '3.2.2',
      site:
    )
  end

  subject do
    described_class.new(name: , parent: , schema: field_schema)
  end

  describe '#anchor' do
    it 'returns the anchor link' do
      expect(subject.anchor).to eq('config')
    end

    context 'nested field' do
      let(:name) { 'session_redis_cluster_nodes' }
      let(:nested_field) { schema.config['fields'].detect { |f| f.key?(name) } }
      let(:parent) { 'config' }
      let(:field_schema) { nested_field.values.first }

      it 'returns the anchor link' do
        expect(subject.anchor).to eq('config-session_redis_cluster_nodes')
      end
    end
  end

  describe '#elements' do
    it 'returns the hash of elements that the field has' do
      expect(subject.elements).to eq({})
    end

    context 'field with elements' do
      let(:name) { 'session_redis_cluster_nodes' }
      let(:nested_field) { schema.config['fields'].detect { |f| f.key?(name) } }
      let(:parent) { 'config' }
      let(:field_schema) { nested_field.values.first }

      it 'generated SchemaFields for every field' do
        expect(subject.elements['fields'].size).to eq(2)
        expect(subject.elements['fields']).to all(be_an(described_class))
      end
    end
  end

  describe '#fields' do
    it 'returns the list of `fields`' do
      expect(subject.fields.size).to eq(54)
      expect(subject.fields).to all(be_an(described_class))
    end
  end

  describe '#referenceable' do
    context 'when the field is referenceable' do
      let(:name) { 'token' }
      let(:parent) { 'vault' }
      let(:field_schema) { { "referenceable" => true, "type" => "string" } }

      it { expect(subject.referenceable).to eq(true) }
    end

    context 'when the field is of type array and its elements are referenceable' do
      let(:name) { 'body' }
      let(:parent) { 'rename' }
      let(:field_schema) do
        {
          "default" => [],
          "type" => "array",
          "elements" => { "type" => "string", "referenceable" => true },
          "description" => "List of parameters..."
        }
      end

      it { expect(subject.referenceable).to eq(true) }
    end
  end
end
