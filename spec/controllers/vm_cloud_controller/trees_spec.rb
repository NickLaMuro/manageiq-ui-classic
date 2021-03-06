describe VmCloudController do
  render_views
  before do
    stub_user(:features => :all)
    MiqRegion.seed
    EvmSpecHelper.create_guid_miq_server_zone
  end

  context "#tree_select" do
    [
      %w(Instances instances_tree),
      %w(Images images_tree),
      %w(Instances instances_filter_tree),
      %w(Images images_filter_tree)
    ].each do |elements, tree|
      it "renders list of #{elements} for #{tree} root node" do
        FactoryBot.create(:vm_openstack)
        FactoryBot.create(:template_openstack)

        session[:settings] = {}
        seed_session_trees('vm_cloud', tree.to_sym)

        post :tree_select, :params => { :id => 'root', :format => :js }

        expect(response).to render_template('layouts/react/_gtl')
        expect(response.status).to eq(200)
      end
    end

    [
      %w(vm_openstack Openstack),
      %w(vm_azure Azure),
      %w(vm_google Google),
      %w(vm_amazon Amazon)
    ].each do |instance, name|
      it "renders Instance details for #{name} node" do
        instance = FactoryBot.create(instance.to_sym, :with_provider)

        session[:settings] = {}
        seed_session_trees('vm_cloud', 'instances_tree')

        post :tree_select, :params => { :id => "v-#{instance.id}", :format => :js }

        expect(response).to render_template('layouts/_textual_groups_generic')
        expect(response.status).to eq(200)
      end
    end
  end
end
